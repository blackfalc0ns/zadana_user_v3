import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';

class CheckoutPromoResultEntity {
  const CheckoutPromoResultEntity({
    required this.message,
    required this.summary,
    required this.shippingBreakdown,
    this.promoCode,
    this.deliveryQuote,
    this.pricingMode,
  });

  final String message;
  final CheckoutPromoCodeEntity? promoCode;
  final CheckoutDeliveryQuoteEntity? deliveryQuote;
  final List<CheckoutShippingLineEntity> shippingBreakdown;
  final String? pricingMode;
  final CheckoutTotalsEntity summary;
}
