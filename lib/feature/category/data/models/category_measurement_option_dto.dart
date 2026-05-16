class CategoryMeasurementOptionDto {
  const CategoryMeasurementOptionDto({
    this.measurementValue,
    this.measurementUnitId,
    this.measurementUnitName,
    this.label,
  });

  factory CategoryMeasurementOptionDto.fromJson(Map<String, dynamic> json) {
    return CategoryMeasurementOptionDto(
      measurementValue: (json['measurement_value'] as num?)?.toDouble(),
      measurementUnitId: json['measurement_unit_id'] as String?,
      measurementUnitName: json['measurement_unit_name'] as String?,
      label: json['label'] as String?,
    );
  }

  final double? measurementValue;
  final String? measurementUnitId;
  final String? measurementUnitName;
  final String? label;

  Map<String, dynamic> toJson() => {
        'measurement_value': measurementValue,
        'measurement_unit_id': measurementUnitId,
        'measurement_unit_name': measurementUnitName,
        'label': label,
      };
}
