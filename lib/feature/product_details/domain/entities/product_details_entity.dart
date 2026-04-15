import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_vendor_price_entity.dart';

class ProductDetailsEntity {
  const ProductDetailsEntity({
    required this.id,
    required this.masterProductId,
    required this.defaultVendorProductId,
    required this.name,
    required this.store,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    required this.images,
    this.rating,
    this.reviewCount,
    this.discount,
    required this.isFavorite,
    this.unit,
    required this.isDiscounted,
    required this.description,
    required this.vendorPrices,
    required this.similarProducts,
  });
  final String id;
  final String masterProductId;
  final String defaultVendorProductId;
  final String name;
  final String store;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final List<String> images;
  final double? rating;
  final int? reviewCount;
  final String? discount;
  final bool isFavorite;
  final String? unit;
  final bool isDiscounted;
  final String description;
  final List<ProductVendorPriceEntity> vendorPrices;
  final List<ProductModel> similarProducts;
}
