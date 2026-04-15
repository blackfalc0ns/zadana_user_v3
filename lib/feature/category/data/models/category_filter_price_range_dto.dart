class CategoryFilterPriceRangeDto {
  const CategoryFilterPriceRangeDto({this.min, this.max});

  factory CategoryFilterPriceRangeDto.fromJson(Map<String, dynamic> json) {
    return CategoryFilterPriceRangeDto(
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
    );
  }
  final double? min;
  final double? max;
}
