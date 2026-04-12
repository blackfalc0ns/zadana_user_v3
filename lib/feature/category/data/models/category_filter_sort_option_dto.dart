class CategoryFilterSortOptionDto {
  final String? label;
  final String? value;

  const CategoryFilterSortOptionDto({
    this.label,
    this.value,
  });

  factory CategoryFilterSortOptionDto.fromJson(Map<String, dynamic> json) {
    return CategoryFilterSortOptionDto(
      label: json['label'] as String?,
      value: json['value'] as String?,
    );
  }
}
