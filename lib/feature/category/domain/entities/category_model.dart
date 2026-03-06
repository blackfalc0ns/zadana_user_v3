class CategoryModel {
  final String id;
  final String name;
  final String imageAsset;
  final int itemsCount;
  final String emoji; // fallback placeholder

  const CategoryModel({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.itemsCount,
    required this.emoji,
  });
}