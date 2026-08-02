import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_summary_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/update_cart_item_quantity_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/clear_cart_usecase.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/get_cart_usecase.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/get_cart_vendors_usecase.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/remove_cart_item_usecase.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/update_cart_item_quantity_usecase.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_event.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_state.dart';

@injectable
class CartViewModel extends Cubit<CartState> {
  CartViewModel(
    this._getCartVendorsUseCase,
    this._getCartUseCase,
    this._clearCartUseCase,
    this._removeCartItemUseCase,
    this._updateCartItemQuantityUseCase,
  ) : super(const CartState());

  final GetCartVendorsUseCase _getCartVendorsUseCase;
  final GetCartUseCase _getCartUseCase;
  final ClearCartUseCase _clearCartUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;
  final UpdateCartItemQuantityUseCase _updateCartItemQuantityUseCase;

  void _emitIfOpen(CartState nextState) {
    if (isClosed) return;
    super.emit(nextState);
  }

  void doIntent(CartEvent event) {
    if (isClosed) return;

    switch (event) {
      case CartLoadVendorsEvent():
      case CartRetryVendorsEvent():
        _loadVendors();
      case CartLoadItemsEvent():
        _loadItems(event.vendorId);
      case CartLoadMoreItemsEvent():
        _loadMoreItems(event.vendorId);
      case CartRetryItemsEvent():
        _loadItems(event.vendorId);
      case CartResetAfterCheckoutEvent():
        _resetAfterCheckout();
      case CartClearAllEvent():
        _clearCart();
      case CartRemoveItemEvent():
        _removeItem(event.item);
      case CartUpdateQuantityEvent():
        _updateQuantity(event);
    }
  }

  void clearCartFeedback() {
    _emitIfOpen(
      state.copyWith(
        clearClearCartSuccessMessage: true,
        clearClearCartErrorMessage: true,
      ),
    );
  }

  void clearRemoveItemFeedback() {
    _emitIfOpen(
      state.copyWith(
        clearRemoveItemSuccessMessage: true,
        clearRemoveItemErrorMessage: true,
        clearRemovedItemId: true,
      ),
    );
  }

  void clearUpdateQuantityFeedback() {
    _emitIfOpen(
      state.copyWith(
        clearUpdateQuantityErrorMessage: true,
        clearUpdatedQuantityItemId: true,
      ),
    );
  }

  void _resetAfterCheckout() {
    _emitIfOpen(
      state.copyWith(
        vendors: const [],
        items: const [],
        summary: const CartSummaryEntity(itemsCount: 0, totalQuantity: 0),
        loadedVendorId: '',
        currentOffset: 0,
        hasMoreItems: true,
        vendorsOffset: 0,
        hasMoreVendors: true,
        isLoadingVendors: false,
        isVendorsSuccess: true,
        isLoadingItems: false,
        isItemsSuccess: true,
        isLoadingMoreItems: false,
        isClearingCart: false,
        isRemovingItem: false,
        clearClearCartSuccessMessage: true,
        clearClearCartErrorMessage: true,
        clearRemoveItemSuccessMessage: true,
        clearRemoveItemErrorMessage: true,
        clearRemovedItemId: true,
        clearUpdateQuantityErrorMessage: true,
        clearUpdatedQuantityItemId: true,
        clearVendorsErrorMessage: true,
        clearItemsErrorMessage: true,
        clearVendorsFailure: true,
        clearItemsFailure: true,
      ),
    );
  }

  Future<void> _loadVendors() async {
    _emitIfOpen(
      state.copyWith(
        isLoadingVendors: true,
        isVendorsSuccess: false,
        vendorsOffset: 0,
        hasMoreVendors: true,
        clearVendorsErrorMessage: true,
        clearVendorsFailure: true,
      ),
    );

    developer.log('Loading cart vendors offset=0', name: 'CartViewModel');

    final result = await _getCartVendorsUseCase.call();
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        developer.log('Cart vendors loaded', name: 'CartViewModel');
        _emitIfOpen(
          state.copyWith(
            isLoadingVendors: false,
            isVendorsSuccess: true,
            vendors: result.data.vendors,
            vendorsOffset: result.data.vendors.length,
            hasMoreVendors: result.data.hasMore,
            clearVendorsErrorMessage: true,
            clearVendorsFailure: true,
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Cart vendors failed: ${result.failure.errorMessage}',
          name: 'CartViewModel',
        );
        _emitIfOpen(
          state.copyWith(
            isLoadingVendors: false,
            isVendorsSuccess: false,
            vendorsErrorMessage: result.failure.code,
            vendorsFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _loadItems(String? vendorId) async {
    _emitIfOpen(
      state.copyWith(
        isLoadingItems: true,
        isItemsSuccess: false,
        currentOffset: 0,
        hasMoreItems: true,
        clearItemsErrorMessage: true,
        clearItemsFailure: true,
      ),
    );

    developer.log('Loading cart items offset=0', name: 'CartViewModel');

    final result = await _getCartUseCase.call(vendorId: vendorId);
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        developer.log('Cart items loaded', name: 'CartViewModel');
        _emitIfOpen(
          state.copyWith(
            isLoadingItems: false,
            isItemsSuccess: true,
            items: result.data.items,
            summary: result.data.summary,
            loadedVendorId: vendorId,
            currentOffset: result.data.items.length,
            hasMoreItems: result.data.hasMore,
            clearItemsErrorMessage: true,
            clearItemsFailure: true,
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Cart items failed: ${result.failure.errorMessage}',
          name: 'CartViewModel',
        );
        _emitIfOpen(
          state.copyWith(
            isLoadingItems: false,
            isItemsSuccess: false,
            itemsErrorMessage: result.failure.code,
            itemsFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _loadMoreItems(String? vendorId) async {
    if (state.isLoadingItems ||
        state.isLoadingMoreItems ||
        !state.hasMoreItems) {
      return;
    }

    final nextOffset = state.currentOffset;

    _emitIfOpen(
      state.copyWith(isLoadingMoreItems: true, clearItemsFailure: true),
    );

    developer.log(
      'Loading cart items offset=$nextOffset',
      name: 'CartViewModel',
    );

    final result = await _getCartUseCase.call(
      vendorId: vendorId,
      offset: nextOffset,
    );
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final allItems = [...state.items, ...result.data.items];
        _emitIfOpen(
          state.copyWith(
            isLoadingMoreItems: false,
            items: allItems,
            summary: result.data.summary,
            currentOffset: allItems.length,
            hasMoreItems: result.data.hasMore,
            clearItemsFailure: true,
          ),
        );
      case ApiErrorResult():
        _emitIfOpen(
          state.copyWith(
            isLoadingMoreItems: false,
            itemsErrorMessage: result.failure.code,
            itemsFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _clearCart() async {
    _emitIfOpen(
      state.copyWith(
        isClearingCart: true,
        clearClearCartSuccessMessage: true,
        clearClearCartErrorMessage: true,
      ),
    );

    developer.log('Clearing cart', name: 'CartViewModel');

    final result = await _clearCartUseCase.call();
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        developer.log('Cart cleared', name: 'CartViewModel');
        _emitIfOpen(
          state.copyWith(
            isClearingCart: false,
            items: const [],
            vendors: const [],
            summary: const CartSummaryEntity(itemsCount: 0, totalQuantity: 0),
            loadedVendorId: '',
            isItemsSuccess: true,
            isVendorsSuccess: true,
            clearCartSuccessMessage: result.data.message,
            clearClearCartErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Clear cart failed: ${result.failure.errorMessage}',
          name: 'CartViewModel',
        );
        _emitIfOpen(
          state.copyWith(
            isClearingCart: false,
            clearCartErrorMessage: result.failure.code,
            clearClearCartSuccessMessage: true,
          ),
        );
    }
  }

  Future<void> _removeItem(CartItemModel item) async {
    _emitIfOpen(
      state.copyWith(
        isRemovingItem: true,
        clearRemoveItemSuccessMessage: true,
        clearRemoveItemErrorMessage: true,
        clearRemovedItemId: true,
      ),
    );

    developer.log('Removing cart item: ${item.id}', name: 'CartViewModel');

    final result = await _removeCartItemUseCase.call(item.id);
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final updatedItems = state.items.where((e) => e.id != item.id).toList();
        developer.log('Cart item removed: ${item.id}', name: 'CartViewModel');
        _emitIfOpen(
          state.copyWith(
            isRemovingItem: false,
            items: updatedItems,
            summary: result.data.summary,
            removedItemId: item.id,
            removeItemSuccessMessage: result.data.message,
            clearRemoveItemErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Remove cart item failed: ${result.failure.errorMessage}',
          name: 'CartViewModel',
        );
        _emitIfOpen(
          state.copyWith(
            isRemovingItem: false,
            removeItemErrorMessage: result.failure.code,
            clearRemoveItemSuccessMessage: true,
            clearRemovedItemId: true,
          ),
        );
    }
  }

  Future<void> _updateQuantity(CartUpdateQuantityEvent event) async {
    developer.log(
      'Updating cart item quantity: ${event.itemId} -> ${event.quantity}',
      name: 'CartViewModel',
    );

    final result = await _updateCartItemQuantityUseCase.call(
      itemId: event.itemId,
      vendorId: event.vendorId,
      request: UpdateCartItemQuantityRequestEntity(quantity: event.quantity),
    );
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final updatedItems = state.items
            .map(
              (item) =>
                  item.id == result.data.item.id ? result.data.item : item,
            )
            .toList();
        _emitIfOpen(
          state.copyWith(
            items: updatedItems,
            summary: result.data.summary,
            updatedQuantityItemId: result.data.item.id,
            clearUpdateQuantityErrorMessage: true,
          ),
        );
      case ApiErrorResult():
        final revertedItems = state.items
            .map(
              (item) => item.id == event.itemId
                  ? item.copyWith(quantity: event.previousQuantity)
                  : item,
            )
            .toList();
        _emitIfOpen(
          state.copyWith(
            items: revertedItems,
            updateQuantityErrorMessage: result.failure.code,
            updatedQuantityItemId: event.itemId,
          ),
        );
    }
  }
}
