import 'package:zadana_user_v3/feature/payment/data/models/checkout_summary_dto.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_promo_result_entity.dart';

class CheckoutPromoResultDto {
  const CheckoutPromoResultDto({
    required this.message,
    required this.summary,
    required this.shippingBreakdown,
    this.promoCode,
    this.deliveryQuote,
    this.pricingMode,
  });

  factory CheckoutPromoResultDto.fromJson(Map<String, dynamic> json) {
    return CheckoutPromoResultDto(
      message: json['message']?.toString() ?? '',
      promoCode: _nullableMap(json['promo_code']) == null
          ? null
          : CheckoutPromoCodeDto.fromJson(_asMap(json['promo_code'])),
      deliveryQuote: _nullableMap(json['delivery_quote']) == null
          ? null
          : CheckoutDeliveryQuoteDto.fromJson(_asMap(json['delivery_quote'])),
      shippingBreakdown: _asList(json['shipping_breakdown'])
          .map((item) => CheckoutShippingLineDto.fromJson(_asMap(item)))
          .toList(),
      pricingMode: json['pricing_mode']?.toString(),
      summary: CheckoutTotalsDto.fromJson(_asMap(json['summary'])),
    );
  }

  final String message;
  final CheckoutPromoCodeDto? promoCode;
  final CheckoutDeliveryQuoteDto? deliveryQuote;
  final List<CheckoutShippingLineDto> shippingBreakdown;
  final String? pricingMode;
  final CheckoutTotalsDto summary;

  CheckoutPromoResultEntity toEntity() {
    return CheckoutPromoResultEntity(
      message: message,
      promoCode: promoCode?.toEntity(),
      deliveryQuote: deliveryQuote?.toEntity(),
      shippingBreakdown: shippingBreakdown.map((item) => item.toEntity()).toList(),
      pricingMode: pricingMode,
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

List<dynamic> _asList(dynamic value) {
  return value is List ? value : const [];
}
