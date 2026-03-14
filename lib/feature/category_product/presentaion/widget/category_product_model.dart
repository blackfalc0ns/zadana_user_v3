class CategoryProductModel {
  final String id;
  final String name;
  final String subCategoryId;
  final double price;
  final double? oldPrice;
  final String emoji;
  final bool isFavorite;
  final String? imageUrl;
  final String? store;
  final double? rating;
  final int? reviewCount;
  final String? discount;
  final String? unit;

  const CategoryProductModel({
    required this.id,
    required this.name,
    required this.subCategoryId,
    required this.price,
    this.oldPrice,
    required this.emoji,
    this.isFavorite = false,
    this.imageUrl,
    this.store,
    this.rating,
    this.reviewCount,
    this.discount,
    this.unit,
  });

  CategoryProductModel copyWith({
    String? id,
    String? name,
    String? subCategoryId,
    double? price,
    double? oldPrice,
    String? emoji,
    bool? isFavorite,
    String? imageUrl,
    String? store,
    double? rating,
    int? reviewCount,
    String? discount,
    String? unit,
  }) {
    return CategoryProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      emoji: emoji ?? this.emoji,
      isFavorite: isFavorite ?? this.isFavorite,
      imageUrl: imageUrl ?? this.imageUrl,
      store: store ?? this.store,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      discount: discount ?? this.discount,
      unit: unit ?? this.unit,
    );
  }
}