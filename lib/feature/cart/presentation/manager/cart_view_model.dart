import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/cart/data/services/guest_cart_sync_service.dart';
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
    this._guestCartSyncService,
  ) : super(const CartState());

  final GetCartVendorsUseCase _getCartVendorsUseCase;
  final GetCartUseCase _getCartUseCase;
  final ClearCartUseCase _clearCartUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;
  final UpdateCartItemQuantityUseCase _updateCartItemQuantityUseCase;
  final GuestCartSyncService _guestCartSyncService;

  void doIntent(CartEvent event) {
    switch (event) {
      case CartLoadVendorsEvent():
      case CartRetryVendorsEvent():
        _loadVendors();
      case CartLoadItemsEvent():
        _loadItems(event.vendorId);
      case CartRetryItemsEvent():
        _loadItems(event.vendorId);
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

  Future<void> _loadVendors() async {
    emit(
      state.copyWith(
        isLoadingVendors: true,
        isVendorsSuccess: false,
        clearVendorsErrorMessage: true,
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
            vendorsErrorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  Future<void> _loadItems(String? vendorId) async {
    emit(
      state.copyWith(
        isLoadingItems: true,
        isItemsSuccess: false,
        clearItemsErrorMessage: true,
      ),
    );

    developer.log('Loading cart items', name: 'CartViewModel');

    final result = await _getCartUseCase.call(vendorId: vendorId);

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
            clearItemsErrorMessage: true,
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
            itemsErrorMessage: result.failure.errorMessage,
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
        await _guestCartSyncService.clearPendingItems();
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
            clearCartErrorMessage: result.failure.errorMessage,
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
        await _guestCartSyncService.removePendingItemByProductId(
          item.productId,
        );
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
            removeItemErrorMessage: result.failure.errorMessage,
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
      request: UpdateCartItemQuantityRequestEntity(quantity: event.quantity),
    );

    switch (result) {
      case ApiSuccessResult():
        await _guestCartSyncService.updatePendingItemQuantity(
          productId: event.productId,
          quantity: result.data.item.quantity,
        );
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
            updateQuantityErrorMessage: result.failure.errorMessage,
            updatedQuantityItemId: event.itemId,
          ),
        );
    }
  }
}
