class BrandFilterOptionDto {
  const BrandFilterOptionDto({this.id, this.name});

  factory BrandFilterOptionDto.fromJson(Map<String, dynamic> json) {
    return BrandFilterOptionDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }
  final String? id;
  final String? name;
}
