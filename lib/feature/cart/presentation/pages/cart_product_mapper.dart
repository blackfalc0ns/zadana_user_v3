import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

ProductModel mapCartItemToProductModel({
  required CartItemModel item,
  required String? selectedVendorId,
  required String? loadedVendorId,
}) {
  final VendorPrice? vendorPrice;
  if (selectedVendorId == null) {
    vendorPrice = item.cheapestOrNull;
  } else {
    vendorPrice = item.vendorPrices.cast<VendorPrice?>().firstWhere(
      (vendor) => vendor?.id == selectedVendorId,
      orElse: () =>
          item.getPriceForVendor(
            selectedVendorId,
            loadedVendorId: loadedVendorId,
          ) ??
          item.cheapestOrNull,
    );
  }

  return ProductModel(
    id: item.productId,
    name: item.name,
    // Product details loads its current availability and prices by product ID.
    // A cart item may have no price at the currently selected vendor, but must
    // still be able to open its details screen.
    store: vendorPrice?.name ?? '',
    price: vendorPrice?.price ?? 0,
    imageUrl: item.imageUrl ?? '',
    unit: item.unit,
    emoji: '',
    isDiscounted: false,
    showPriceOnCard: vendorPrice != null,
  );
}
