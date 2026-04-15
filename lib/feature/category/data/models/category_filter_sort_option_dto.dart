class CategoryFilterSortOptionDto {
  const CategoryFilterSortOptionDto({this.label, this.value});

  factory CategoryFilterSortOptionDto.fromJson(Map<String, dynamic> json) {
    return CategoryFilterSortOptionDto(
      label: json['label'] as String?,
      value: json['value'] as String?,
    );
  }
  final String? label;
  final String? value;
}
