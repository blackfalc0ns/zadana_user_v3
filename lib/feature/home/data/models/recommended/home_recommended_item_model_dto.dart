class HomeRecommendedItemModelDto {
  const HomeRecommendedItemModelDto({
    this.id,
    this.name,
    this.store,
    this.price,
    this.oldPrice,
    this.imageUrl,
    this.rating,
    this.reviewCount,
    this.discount,
    this.isFavorite,
    this.isFeatured,
    this.unit,
    this.isDiscounted,
  });

  factory HomeRecommendedItemModelDto.fromJson(Map<String, dynamic> json) {
    return HomeRecommendedItemModelDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      store: json['store'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      oldPrice: (json['old_price'] as num?)?.toDouble(),
      imageUrl: json['image_url'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int?,
      discount: json['discount'] as String?,
      isFavorite: json['is_favorite'] as bool?,
      isFeatured: json['is_featured'] as bool?,
      unit: json['unit'] as String?,
      isDiscounted: json['is_discounted'] as bool?,
    );
  }
  final String? id;
  final String? name;
  final String? store;
  final double? price;
  final double? oldPrice;
  final String? imageUrl;
  final double? rating;
  final int? reviewCount;
  final String? discount;
  final bool? isFavorite;
  final bool? isFeatured;
  final String? unit;
  final bool? isDiscounted;
}
