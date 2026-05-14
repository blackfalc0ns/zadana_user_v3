class BrandFilterSubcategoryEntity {
  const BrandFilterSubcategoryEntity({
    required this.id,
    required this.name,
    required this.categoryId,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String categoryId;
  final String? imageUrl;
}
