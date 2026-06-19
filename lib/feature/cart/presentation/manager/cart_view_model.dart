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

  static const int _perPage = 20;

  void doIntent(CartEvent event) {
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
    emit(
      state.copyWith(
        clearClearCartSuccessMessage: true,
        clearClearCartErrorMessage: true,
      ),
    );
  }

  void clearRemoveItemFeedback() {
    emit(
      state.copyWith(
        clearRemoveItemSuccessMessage: true,
        clearRemoveItemErrorMessage: true,
        clearRemovedItemId: true,
      ),
    );
  }

  void clearUpdateQuantityFeedback() {
    emit(
      state.copyWith(
        clearUpdateQuantityErrorMessage: true,
        clearUpdatedQuantityItemId: true,
      ),
    );
  }

  void _resetAfterCheckout() {
    emit(
      state.copyWith(
        vendors: const [],
        items: const [],
        summary: const CartSummaryEntity(itemsCount: 0, totalQuantity: 0),
        loadedVendorId: '',
        currentPage: 1,
        hasMoreItems: true,
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
    emit(
      state.copyWith(
        isLoadingVendors: true,
        isVendorsSuccess: false,
        clearVendorsErrorMessage: true,
        clearVendorsFailure: true,
      ),
    );

    developer.log('Loading cart vendors', name: 'CartViewModel');

    final result = await _getCartVendorsUseCase.call();

    switch (result) {
      case ApiSuccessResult():
        developer.log('Cart vendors loaded', name: 'CartViewModel');
        emit(
          state.copyWith(
            isLoadingVendors: false,
            isVendorsSuccess: true,
            vendors: result.data.vendors,
            clearVendorsErrorMessage: true,
            clearVendorsFailure: true,
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Cart vendors failed: ${result.failure.errorMessage}',
          name: 'CartViewModel',
        );
        emit(
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
    emit(
      state.copyWith(
        isLoadingItems: true,
        isItemsSuccess: false,
        currentPage: 1,
        hasMoreItems: true,
        clearItemsErrorMessage: true,
        clearItemsFailure: true,
      ),
    );

    developer.log('Loading cart items page 1', name: 'CartViewModel');

    final result = await _getCartUseCase.call(
      vendorId: vendorId,
      page: 1,
      perPage: _perPage,
    );

    switch (result) {
      case ApiSuccessResult():
        developer.log('Cart items loaded', name: 'CartViewModel');
        emit(
          state.copyWith(
            isLoadingItems: false,
            isItemsSuccess: true,
            items: result.data.items,
            summary: result.data.summary,
            loadedVendorId: vendorId,
            currentPage: result.data.page,
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
        emit(
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
    if (state.isLoadingItems || state.isLoadingMoreItems || !state.hasMoreItems) {
      return;
    }

    final nextPage = state.currentPage + 1;

    emit(state.copyWith(isLoadingMoreItems: true, clearItemsFailure: true));

    developer.log('Loading cart items page $nextPage', name: 'CartViewModel');

    final result = await _getCartUseCase.call(
      vendorId: vendorId,
      page: nextPage,
      perPage: _perPage,
    );

    switch (result) {
      case ApiSuccessResult():
        final allItems = [...state.items, ...result.data.items];
        emit(
          state.copyWith(
            isLoadingMoreItems: false,
            items: allItems,
            summary: result.data.summary,
            currentPage: result.data.page,
            hasMoreItems: result.data.hasMore,
            clearItemsFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoadingMoreItems: false,
            itemsErrorMessage: result.failure.code,
            itemsFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _clearCart() async {
    emit(
      state.copyWith(
        isClearingCart: true,
        clearClearCartSuccessMessage: true,
        clearClearCartErrorMessage: true,
      ),
    );

    developer.log('Clearing cart', name: 'CartViewModel');

    final result = await _clearCartUseCase.call();

    switch (result) {
      case ApiSuccessResult():
        developer.log('Cart cleared', name: 'CartViewModel');
        emit(
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
        emit(
          state.copyWith(
            isClearingCart: false,
            clearCartErrorMessage: result.failure.code,
            clearClearCartSuccessMessage: true,
          ),
        );
    }
  }

  Future<void> _removeItem(CartItemModel item) async {
    emit(
      state.copyWith(
        isRemovingItem: true,
        clearRemoveItemSuccessMessage: true,
        clearRemoveItemErrorMessage: true,
        clearRemovedItemId: true,
      ),
    );

    developer.log('Removing cart item: ${item.id}', name: 'CartViewModel');

    final result = await _removeCartItemUseCase.call(item.id);

    switch (result) {
      case ApiSuccessResult():
        final updatedItems = state.items.where((e) => e.id != item.id).toList();
        developer.log('Cart item removed: ${item.id}', name: 'CartViewModel');
        emit(
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
        emit(
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

    switch (result) {
      case ApiSuccessResult():
        final updatedItems = state.items
            .map(
              (item) =>
                  item.id == result.data.item.id ? result.data.item : item,
            )
            .toList();
        emit(
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
        emit(
          state.copyWith(
            items: revertedItems,
            updateQuantityErrorMessage: result.failure.code,
            updatedQuantityItemId: event.itemId,
          ),
        );
    }
  }
}
