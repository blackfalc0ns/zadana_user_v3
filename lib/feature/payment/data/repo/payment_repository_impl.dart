import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/payment/data/data_source/payment_remote_data_source.dart';
import 'package:zadana_user_v3/feature/payment/data/models/place_order_request_dto.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_config_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_promo_result_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/confirm_payment_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_request_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/pickup_branch_option_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/repo/payment_repository.dart';

@Injectable(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl(this._remoteDataSource);

  final PaymentRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<CheckoutConfigEntity>> getCheckoutConfig() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCheckoutConfig();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<CheckoutSummaryEntity>> getCheckoutSummary({
    String? vendorId,
    String? fulfillmentType,
    String? addressId,
    String? deliverySlotId,
    String? vendorBranchId,
    String? paymentMethod,
    String? promoCode,
  }) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCheckoutSummary(
        vendorId: vendorId,
        fulfillmentType: fulfillmentType,
        addressId: addressId,
        deliverySlotId: deliverySlotId,
        vendorBranchId: vendorBranchId,
        paymentMethod: paymentMethod,
        promoCode: promoCode,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<CheckoutPromoResultEntity>> applyPromoCode(
    String code, {
    String? vendorId,
    String? fulfillmentType,
    String? vendorBranchId,
    String? paymentMethod,
  }) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.applyPromoCode(
        code,
        vendorId: vendorId,
        fulfillmentType: fulfillmentType,
        vendorBranchId: vendorBranchId,
        paymentMethod: paymentMethod,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<CheckoutPromoResultEntity>> removePromoCode({
    String? vendorId,
    String? fulfillmentType,
    String? vendorBranchId,
    String? paymentMethod,
  }) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.removePromoCode(
        vendorId: vendorId,
        fulfillmentType: fulfillmentType,
        vendorBranchId: vendorBranchId,
        paymentMethod: paymentMethod,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<PlaceOrderResponseEntity>> placeOrder(
    PlaceOrderRequestEntity request,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.placeOrder(request.toDto());
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<List<PickupBranchOptionEntity>>> getPickupBranches({
    String? vendorId,
    String? addressId,
    String? city,
  }) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getPickupBranches(
        vendorId: vendorId,
        addressId: addressId,
        city: city,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<ConfirmPaymentResponseEntity>> confirmMoyasarPayment(
    String moyasarPaymentId,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.confirmMoyasarPayment(
        moyasarPaymentId,
      );
      return response.toEntity();
    });
  }
}
