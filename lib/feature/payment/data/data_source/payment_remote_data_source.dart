import 'package:zadana_user_v3/feature/payment/data/models/checkout_promo_result_dto.dart';
import 'package:zadana_user_v3/feature/payment/data/models/checkout_summary_dto.dart';
import 'package:zadana_user_v3/feature/payment/data/models/confirm_payment_response_dto.dart';
import 'package:zadana_user_v3/feature/payment/data/models/place_order_request_dto.dart';
import 'package:zadana_user_v3/feature/payment/data/models/place_order_response_dto.dart';

abstract class PaymentRemoteDataSource {
  Future<CheckoutSummaryDto> getCheckoutSummary({
    String? vendorId,
    String? addressId,
    String? deliverySlotId,
    String? paymentMethod,
    String? promoCode,
  });

  Future<CheckoutPromoResultDto> applyPromoCode(
    String code, {
    String? vendorId,
    String? paymentMethod,
  });

  Future<CheckoutPromoResultDto> removePromoCode({
    String? vendorId,
    String? paymentMethod,
  });

  Future<PlaceOrderResponseDto> placeOrder(PlaceOrderRequestDto request);

  /// Confirms a Moyasar payment with the backend using the provider payment ID.
  Future<ConfirmPaymentResponseDto> confirmMoyasarPayment(
    String moyasarPaymentId,
  );
}
