class CategoryFilterOptionDto {
  const CategoryFilterOptionDto({this.id, this.name});

  factory CategoryFilterOptionDto.fromJson(Map<String, dynamic> json) {
    return CategoryFilterOptionDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }
  final String? id;
  final String? name;
}
