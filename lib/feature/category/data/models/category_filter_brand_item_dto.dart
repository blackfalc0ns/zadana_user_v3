class CategoryFilterBrandItemDto {
  final String? id;
  final String? name;
  final String? logoUrl;

  const CategoryFilterBrandItemDto({
    this.id,
    this.name,
    this.logoUrl,
  });

  factory CategoryFilterBrandItemDto.fromJson(Map<String, dynamic> json) {
    return CategoryFilterBrandItemDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      logoUrl: json['logo_url'] as String?,
    );
  }
}
