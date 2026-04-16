import 'package:zadana_user_v3/feature/payment/data/models/checkout_summary_dto.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_promo_result_entity.dart';

class CheckoutPromoResultDto {
  const CheckoutPromoResultDto({
    required this.message,
    required this.summary,
    this.promoCode,
  });

  factory CheckoutPromoResultDto.fromJson(Map<String, dynamic> json) {
    return CheckoutPromoResultDto(
      message: json['message']?.toString() ?? '',
      promoCode: _nullableMap(json['promo_code']) == null
          ? null
          : CheckoutPromoCodeDto.fromJson(_asMap(json['promo_code'])),
      summary: CheckoutTotalsDto.fromJson(_asMap(json['summary'])),
    );
  }

  final String message;
  final CheckoutPromoCodeDto? promoCode;
  final CheckoutTotalsDto summary;

  CheckoutPromoResultEntity toEntity() {
    return CheckoutPromoResultEntity(
      message: message,
      promoCode: promoCode?.toEntity(),
      summary: summary.toEntity(),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  return value is Map<String, dynamic> ? value : <String, dynamic>{};
}

Map<String, dynamic>? _nullableMap(dynamic value) {
  return value is Map<String, dynamic> ? value : null;
}
