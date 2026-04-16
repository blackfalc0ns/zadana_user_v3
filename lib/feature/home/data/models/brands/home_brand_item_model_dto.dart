class HomeBrandItemModelDto {
  const HomeBrandItemModelDto({
    this.id,
    this.name,
    this.logo,
    this.coverImage,
    this.productCount,
    this.description,
  });

  factory HomeBrandItemModelDto.fromJson(Map<String, dynamic> json) {
    return HomeBrandItemModelDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      logo: json['logo'] as String?,
      coverImage: json['cover_image'] as String?,
      productCount: json['product_count'] as int?,
      description: json['description'] as String?,
    );
  }
  final String? id;
  final String? name;
  final String? logo;
  final String? coverImage;
  final int? productCount;
  final String? description;
}
