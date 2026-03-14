class CategoryEntity {
  final String id;
  final String name;
  final String imageAsset;
  final String emoji;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.emoji,
  });

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? imageAsset,
    String? emoji,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imageAsset: imageAsset ?? this.imageAsset,
      emoji: emoji ?? this.emoji,
    );
  }
}