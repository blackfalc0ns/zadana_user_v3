import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_summary_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendor_entity.dart';

class CartState {
  const CartState({
    this.isLoadingVendors = false,
    this.isVendorsSuccess = false,
    this.isLoadingItems = false,
    this.isItemsSuccess = false,
    this.isLoadingMoreItems = false,
    this.isClearingCart = false,
    this.isRemovingItem = false,
    this.vendors = const [],
    this.items = const [],
    this.summary,
    this.loadedVendorId,
    this.currentPage = 1,
    this.hasMoreItems = true,
    this.clearCartSuccessMessage,
    this.clearCartErrorMessage,
    this.removeItemSuccessMessage,
    this.removeItemErrorMessage,
    this.removedItemId,
    this.updateQuantityErrorMessage,
    this.updatedQuantityItemId,
    this.vendorsErrorMessage,
    this.itemsErrorMessage,
    this.vendorsFailure,
    this.itemsFailure,
  });

  final bool isLoadingVendors;
  final bool isVendorsSuccess;
  final bool isLoadingItems;
  final bool isItemsSuccess;
  final bool isLoadingMoreItems;
  final bool isClearingCart;
  final bool isRemovingItem;
  final List<CartVendorEntity> vendors;
  final List<CartItemModel> items;
  final CartSummaryEntity? summary;
  final String? loadedVendorId;
  final int currentPage;
  final bool hasMoreItems;
  final String? clearCartSuccessMessage;
  final String? clearCartErrorMessage;
  final String? removeItemSuccessMessage;
  final String? removeItemErrorMessage;
  final String? removedItemId;
  final String? updateQuantityErrorMessage;
  final String? updatedQuantityItemId;
  final String? vendorsErrorMessage;
  final String? itemsErrorMessage;
  final Failure? vendorsFailure;
  final Failure? itemsFailure;

  CartState copyWith({
    bool? isLoadingVendors,
    bool? isVendorsSuccess,
    bool? isLoadingItems,
    bool? isItemsSuccess,
    bool? isLoadingMoreItems,
    bool? isClearingCart,
    bool? isRemovingItem,
    List<CartVendorEntity>? vendors,
    List<CartItemModel>? items,
    CartSummaryEntity? summary,
    String? loadedVendorId,
    int? currentPage,
    bool? hasMoreItems,
    String? clearCartSuccessMessage,
    String? clearCartErrorMessage,
    String? removeItemSuccessMessage,
    String? removeItemErrorMessage,
    String? removedItemId,
    String? updateQuantityErrorMessage,
    String? updatedQuantityItemId,
    String? vendorsErrorMessage,
    String? itemsErrorMessage,
    Failure? vendorsFailure,
    Failure? itemsFailure,
    bool clearClearCartSuccessMessage = false,
    bool clearClearCartErrorMessage = false,
    bool clearRemoveItemSuccessMessage = false,
    bool clearRemoveItemErrorMessage = false,
    bool clearRemovedItemId = false,
    bool clearUpdateQuantityErrorMessage = false,
    bool clearUpdatedQuantityItemId = false,
    bool clearVendorsErrorMessage = false,
    bool clearItemsErrorMessage = false,
    bool clearVendorsFailure = false,
    bool clearItemsFailure = false,
  }) {
    return CartState(
      isLoadingVendors: isLoadingVendors ?? this.isLoadingVendors,
      isVendorsSuccess: isVendorsSuccess ?? this.isVendorsSuccess,
      isLoadingItems: isLoadingItems ?? this.isLoadingItems,
      isItemsSuccess: isItemsSuccess ?? this.isItemsSuccess,
      isLoadingMoreItems: isLoadingMoreItems ?? this.isLoadingMoreItems,
      isClearingCart: isClearingCart ?? this.isClearingCart,
      isRemovingItem: isRemovingItem ?? this.isRemovingItem,
      vendors: vendors ?? this.vendors,
      items: items ?? this.items,
      summary: summary ?? this.summary,
      loadedVendorId: loadedVendorId ?? this.loadedVendorId,
      currentPage: currentPage ?? this.currentPage,
      hasMoreItems: hasMoreItems ?? this.hasMoreItems,
      clearCartSuccessMessage: clearClearCartSuccessMessage
          ? null
          : clearCartSuccessMessage ?? this.clearCartSuccessMessage,
      clearCartErrorMessage: clearClearCartErrorMessage
          ? null
          : clearCartErrorMessage ?? this.clearCartErrorMessage,
      removeItemSuccessMessage: clearRemoveItemSuccessMessage
          ? null
          : removeItemSuccessMessage ?? this.removeItemSuccessMessage,
      removeItemErrorMessage: clearRemoveItemErrorMessage
          ? null
          : removeItemErrorMessage ?? this.removeItemErrorMessage,
      removedItemId: clearRemovedItemId
          ? null
          : removedItemId ?? this.removedItemId,
      updateQuantityErrorMessage: clearUpdateQuantityErrorMessage
          ? null
          : updateQuantityErrorMessage ?? this.updateQuantityErrorMessage,
      updatedQuantityItemId: clearUpdatedQuantityItemId
          ? null
          : updatedQuantityItemId ?? this.updatedQuantityItemId,
      vendorsErrorMessage: clearVendorsErrorMessage
          ? null
          : vendorsErrorMessage ?? this.vendorsErrorMessage,
      itemsErrorMessage: clearItemsErrorMessage
          ? null
          : itemsErrorMessage ?? this.itemsErrorMessage,
      vendorsFailure: clearVendorsFailure
          ? null
          : vendorsFailure ?? this.vendorsFailure,
      itemsFailure: clearItemsFailure
          ? null
          : itemsFailure ?? this.itemsFailure,
    );
  }
}
