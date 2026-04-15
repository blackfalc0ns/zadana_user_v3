class BrandFilterSubcategoryItemDto {
  const BrandFilterSubcategoryItemDto({this.id, this.name, this.categoryId});

  factory BrandFilterSubcategoryItemDto.fromJson(Map<String, dynamic> json) {
    return BrandFilterSubcategoryItemDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      categoryId: json['category_id'] as String?,
    );
  }
  final String? id;
  final String? name;
  final String? categoryId;
}
