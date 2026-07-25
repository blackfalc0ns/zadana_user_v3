import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_config_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_promo_result_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/confirm_payment_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_request_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/pickup_branch_option_entity.dart';

abstract class PaymentRepository {
  Future<ApiResult<CheckoutConfigEntity>> getCheckoutConfig();

  Future<ApiResult<CheckoutSummaryEntity>> getCheckoutSummary({
    String? vendorId,
    String? fulfillmentType,
    String? addressId,
    String? deliverySlotId,
    String? vendorBranchId,
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

  Future<ApiResult<List<PickupBranchOptionEntity>>> getPickupBranches({
    String? vendorId,
    String? addressId,
    String? city,
  });

  /// Confirms a Moyasar payment with the backend.
  Future<ApiResult<ConfirmPaymentResponseEntity>> confirmMoyasarPayment(
    String moyasarPaymentId,
  );
}
