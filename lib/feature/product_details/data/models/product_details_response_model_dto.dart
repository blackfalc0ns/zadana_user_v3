import 'package:zadana_user_v3/feature/product_details/data/models/product_vendor_price_model_dto.dart';
import 'package:zadana_user_v3/feature/product_details/data/models/similar_product_model_dto.dart';

class ProductDetailsResponseModelDto {
  final String? id;
  final String? masterProductId;
  final String? defaultVendorProductId;
  final String? name;
  final String? store;
  final double? price;
  final double? oldPrice;
  final String? imageUrl;
  final List<String>? images;
  final double? rating;
  final int? reviewCount;
  final String? discount;
  final bool? isFavorite;
  final String? unit;
  final bool? isDiscounted;
  final String? description;
  final List<ProductVendorPriceModelDto>? vendorPrices;
  final List<SimilarProductModelDto>? similarProducts;

  const ProductDetailsResponseModelDto({
    this.id,
    this.masterProductId,
    this.defaultVendorProductId,
    this.name,
    this.store,
    this.price,
    this.oldPrice,
    this.imageUrl,
    this.images,
    this.rating,
    this.reviewCount,
    this.discount,
    this.isFavorite,
    this.unit,
    this.isDiscounted,
    this.description,
    this.vendorPrices,
    this.similarProducts,
  });

  factory ProductDetailsResponseModelDto.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponseModelDto(
      id: json['id'] as String?,
      masterProductId: json['master_product_id'] as String?,
      defaultVendorProductId: json['default_vendor_product_id'] as String?,
      name: json['name'] as String?,
      store: json['store'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      oldPrice: (json['old_price'] as num?)?.toDouble(),
      imageUrl: json['image_url'] as String?,
      images: (json['images'] as List<dynamic>?)?.cast<String>(),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int?,
      discount: json['discount'] as String?,
      isFavorite: json['is_favorite'] as bool?,
      unit: json['unit'] as String?,
      isDiscounted: json['is_discounted'] as bool?,
      description: json['description'] as String?,
      vendorPrices: (json['vendor_prices'] as List<dynamic>?)
          ?.map(
            (item) => ProductVendorPriceModelDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      similarProducts: (json['similar_products'] as List<dynamic>?)
          ?.map(
            (item) =>
                SimilarProductModelDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
