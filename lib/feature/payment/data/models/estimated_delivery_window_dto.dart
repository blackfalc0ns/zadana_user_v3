import 'package:zadana_user_v3/feature/payment/domain/entities/estimated_delivery_window_entity.dart';

class EstimatedDeliveryWindowDto {
  const EstimatedDeliveryWindowDto({
    required this.minMinutes,
    required this.maxMinutes,
    required this.title,
    required this.label,
    required this.subtitle,
    required this.confidence,
    required this.source,
    required this.isApproximate,
  });

  factory EstimatedDeliveryWindowDto.fromJson(Map<String, dynamic> json) {
    return EstimatedDeliveryWindowDto(
      minMinutes: _asInt(json['min_minutes']),
      maxMinutes: _asInt(json['max_minutes']),
      title: json['title']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      confidence: json['confidence']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      isApproximate: json['is_approximate'] == true,
    );
  }

  final int minMinutes;
  final int maxMinutes;
  final String title;
  final String label;
  final String subtitle;
  final String confidence;
  final String source;
  final bool isApproximate;

  EstimatedDeliveryWindowEntity toEntity() {
    return EstimatedDeliveryWindowEntity(
      minMinutes: minMinutes,
      maxMinutes: maxMinutes,
      title: title,
      label: label,
      subtitle: subtitle,
      confidence: confidence,
      source: source,
      isApproximate: isApproximate,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
