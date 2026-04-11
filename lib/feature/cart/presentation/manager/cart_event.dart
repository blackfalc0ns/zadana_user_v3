import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';

sealed class CartEvent {
  const CartEvent();
}

class CartLoadVendorsEvent extends CartEvent {
  const CartLoadVendorsEvent();
}

class CartRetryVendorsEvent extends CartEvent {
  const CartRetryVendorsEvent();
}

class CartLoadItemsEvent extends CartEvent {
  const CartLoadItemsEvent({this.vendorId});

  final String? vendorId;
}

class CartRetryItemsEvent extends CartEvent {
  const CartRetryItemsEvent({this.vendorId});

  final String? vendorId;
}

class CartClearAllEvent extends CartEvent {
  const CartClearAllEvent();
}

class CartRemoveItemEvent extends CartEvent {
  const CartRemoveItemEvent(this.item);

  final CartItemModel item;
}

class CartUpdateQuantityEvent extends CartEvent {
  const CartUpdateQuantityEvent({
    required this.itemId,
    required this.productId,
    required this.quantity,
    required this.previousQuantity,
  });

  final String itemId;
  final String productId;
  final int quantity;
  final int previousQuantity;
}
