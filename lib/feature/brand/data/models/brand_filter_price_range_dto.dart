class BrandFilterPriceRangeDto {
  const BrandFilterPriceRangeDto({this.min, this.max});

  factory BrandFilterPriceRangeDto.fromJson(Map<String, dynamic> json) {
    return BrandFilterPriceRangeDto(
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
    );
  }
  final double? min;
  final double? max;
}
