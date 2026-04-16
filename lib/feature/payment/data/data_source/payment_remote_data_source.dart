import 'package:zadana_user_v3/feature/payment/data/models/checkout_promo_result_dto.dart';
import 'package:zadana_user_v3/feature/payment/data/models/checkout_summary_dto.dart';
import 'package:zadana_user_v3/feature/payment/data/models/place_order_request_dto.dart';
import 'package:zadana_user_v3/feature/payment/data/models/place_order_response_dto.dart';

abstract class PaymentRemoteDataSource {
  Future<CheckoutSummaryDto> getCheckoutSummary({
    String? addressId,
    String? deliverySlotId,
  });

  Future<CheckoutPromoResultDto> applyPromoCode(String code);

  Future<CheckoutPromoResultDto> removePromoCode();

  Future<PlaceOrderResponseDto> placeOrder(PlaceOrderRequestDto request);
}
