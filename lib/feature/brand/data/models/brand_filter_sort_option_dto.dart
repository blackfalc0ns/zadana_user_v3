class BrandFilterSortOptionDto {
  const BrandFilterSortOptionDto({this.label, this.value});

  factory BrandFilterSortOptionDto.fromJson(Map<String, dynamic> json) {
    return BrandFilterSortOptionDto(
      label: json['label'] as String?,
      value: json['value'] as String?,
    );
  }
  final String? label;
  final String? value;
}
