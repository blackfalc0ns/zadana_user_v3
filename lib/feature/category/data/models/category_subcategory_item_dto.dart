class CategorySubcategoryItemDto {
  final String? id;
  final String? name;
  final String? imageUrl;

  const CategorySubcategoryItemDto({
    this.id,
    this.name,
    this.imageUrl,
  });

  factory CategorySubcategoryItemDto.fromJson(Map<String, dynamic> json) {
    return CategorySubcategoryItemDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }
}
