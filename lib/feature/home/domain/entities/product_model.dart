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
  });
}