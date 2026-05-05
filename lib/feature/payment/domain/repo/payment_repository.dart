import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_promo_result_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_request_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';

abstract class PaymentRepository {
  Future<ApiResult<CheckoutSummaryEntity>> getCheckoutSummary({
    String? vendorId,
    String? addressId,
    String? deliverySlotId,
    String? paymentMethod,
    String? promoCode,
  });

  Future<ApiResult<CheckoutPromoResultEntity>> applyPromoCode(
    String code, {
    String? vendorId,
    String? paymentMethod,
  });

  Future<ApiResult<CheckoutPromoResultEntity>> removePromoCode({
    String? vendorId,
    String? paymentMethod,
  });

  Future<ApiResult<PlaceOrderResponseEntity>> placeOrder(
    PlaceOrderRequestEntity request,
  );
}
