class CategoryFilterPartItemDto {
  const CategoryFilterPartItemDto({this.id, this.name, this.productTypeId});

  factory CategoryFilterPartItemDto.fromJson(Map<String, dynamic> json) {
    return CategoryFilterPartItemDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      productTypeId: json['product_type_id'] as String?,
    );
  }
  final String? id;
  final String? name;
  final String? productTypeId;
}
