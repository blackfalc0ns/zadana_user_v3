import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';

class CheckoutPromoResultEntity {
  const CheckoutPromoResultEntity({
    required this.message,
    required this.summary,
    this.promoCode,
  });

  final String message;
  final CheckoutPromoCodeEntity? promoCode;
  final CheckoutTotalsEntity summary;
}
