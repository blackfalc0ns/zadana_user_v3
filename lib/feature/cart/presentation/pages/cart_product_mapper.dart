import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

ProductModel mapCartItemToProductModel({
  required CartItemModel item,
  required String? selectedVendorId,
  required String? loadedVendorId,
}) {
  final vendorPrice = selectedVendorId == null
      ? item.cheapest
      : item.vendorPrices.firstWhere(
          (vendor) => vendor.id == selectedVendorId,
          orElse: () =>
              item.getPriceForVendor(
                selectedVendorId,
                loadedVendorId: loadedVendorId,
              ) ??
              item.cheapest,
        );

  return ProductModel(
    id: item.productId,
    name: item.name,
    store: vendorPrice.name,
    price: vendorPrice.price,
    imageUrl: item.imageUrl,
    unit: item.unit,
    emoji: '',
    isDiscounted: false,
  );
}
