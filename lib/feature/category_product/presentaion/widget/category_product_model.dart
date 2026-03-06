class SubCategoryModel {
  final String id;
  final String name;

  const SubCategoryModel({required this.id, required this.name});
}

class CategoryProductModel {
  final String id;
  final String name;
  final String subCategoryId;
  final double price;
  final double? oldPrice;
  final String emoji; // ← بدل imageUrl
  final bool isFavorite;

  const CategoryProductModel({
    required this.id,
    required this.name,
    required this.subCategoryId,
    required this.price,
    this.oldPrice,
    required this.emoji,
    this.isFavorite = false,
  });
}