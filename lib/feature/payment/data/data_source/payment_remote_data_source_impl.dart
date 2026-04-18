import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/feature/payment/data/data_source/payment_remote_data_source.dart';
import 'package:zadana_user_v3/feature/payment/data/models/checkout_promo_result_dto.dart';
import 'package:zadana_user_v3/feature/payment/data/models/checkout_summary_dto.dart';
import 'package:zadana_user_v3/feature/payment/data/models/place_order_request_dto.dart';
import 'package:zadana_user_v3/feature/payment/data/models/place_order_response_dto.dart';

@Injectable(as: PaymentRemoteDataSource)
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  const PaymentRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  static const String _checkoutSummaryEndpoint = '/checkout/summary';
  static const String _promoCodeEndpoint = '/checkout/promo-code';
  static const String _ordersEndpoint = '/orders';

  Options _noCacheOptions() {
    return Options(
      extra: CacheOptions(
        store: getIt<CacheStore>(),
        policy: CachePolicy.noCache,
      ).toExtra(),
    );
  }

  @override
  Future<CheckoutSummaryDto> getCheckoutSummary({
    String? addressId,
    String? deliverySlotId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _checkoutSummaryEndpoint,
      queryParameters: {
        if (addressId != null && addressId.isNotEmpty) 'address_id': addressId,
        if (deliverySlotId != null && deliverySlotId.isNotEmpty)
          'delivery_slot_id': deliverySlotId,
      },
      options: _noCacheOptions(),
    );

    return CheckoutSummaryDto.fromJson(response.data ?? <String, dynamic>{});
  }

  @override
  Future<CheckoutPromoResultDto> applyPromoCode(String code) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _promoCodeEndpoint,
      data: {'code': code},
    );

    return CheckoutPromoResultDto.fromJson(response.data ?? <String, dynamic>{});
  }

  @override
  Future<CheckoutPromoResultDto> removePromoCode() async {
    final response = await _dio.delete<Map<String, dynamic>>(_promoCodeEndpoint);

    return CheckoutPromoResultDto.fromJson(response.data ?? <String, dynamic>{});
  }

  @override
  Future<PlaceOrderResponseDto> placeOrder(PlaceOrderRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _ordersEndpoint,
      data: request.toJson(),
    );

    return PlaceOrderResponseDto.fromJson(response.data ?? <String, dynamic>{});
  }
}
