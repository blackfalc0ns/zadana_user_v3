class ProductModel {
  final String id;
  final String name;
  final String store;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final double? rating;
  final int? reviewCount;
  final String? discount;
  final bool isFavorite;
  final String? unit;
  final String? emoji; // ← fallback لو الصورة مش شغالة
  final bool  isDiscounted ;

  const ProductModel({
    required this.id,
    required this.name,
    required this.store,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    this.rating,
    this.reviewCount,
    this.discount,
    this.isFavorite = false,
    this.unit,
    this.emoji,
   required this.isDiscounted,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? store,
    double? price,
    double? oldPrice,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    String? discount,
    bool? isFavorite,
    String? unit,
    String? emoji,
    bool ? isDiscounted,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      store: store ?? this.store,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      discount: discount ?? this.discount,
      isFavorite: isFavorite ?? this.isFavorite,
      unit: unit ?? this.unit,
      emoji: emoji ?? this.emoji,
     isDiscounted: isDiscounted ?? this.isDiscounted,
    );
  }

  int get discountPercentage {
    if (discount != null && discount!.trim().isNotEmpty) {
      final parsed = int.tryParse(discount!.replaceAll('%', '').trim());
      if (parsed != null && parsed > 0) {
        return parsed;
      }
    }

    if (oldPrice != null && oldPrice! > price && oldPrice! > 0) {
      final percentage = (((oldPrice! - price) / oldPrice!) * 100).round();
      if (percentage > 0) {
        return percentage;
      }
    }

    return 0;
  }
}
