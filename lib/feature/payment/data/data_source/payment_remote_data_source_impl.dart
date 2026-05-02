import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/network/network_constants.dart';
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
  static const String _placeOrderEndpoint = '/orders';
  static const Map<String, String> _noStoreHeaders = {
    'Cache-Control': 'no-store, no-cache, must-revalidate',
    'Pragma': 'no-cache',
    'Expires': '0',
  };

  Options _noCacheOptions() {
    return Options(
      headers: _noStoreHeaders,
      extra: CacheOptions(
        store: getIt<CacheStore>(),
        policy: CachePolicy.noCache,
      ).toExtra(),
    );
  }

  Future<void> _clearCheckoutSummaryCache() {
    return getIt<CacheStore>().deleteFromPath(
      RegExp(
        '^${RegExp.escape('${NetworkConstants.baseUrl}$_checkoutSummaryEndpoint')}(?:[/?].*)?\$',
      ),
    );
  }

  @override
  Future<CheckoutSummaryDto> getCheckoutSummary({
    String? addressId,
    String? deliverySlotId,
  }) async {
    await _clearCheckoutSummaryCache();

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
    await _clearCheckoutSummaryCache();

    final response = await _dio.post<Map<String, dynamic>>(
      _promoCodeEndpoint,
      data: {'code': code},
      options: _noCacheOptions(),
    );

    await _clearCheckoutSummaryCache();

    return CheckoutPromoResultDto.fromJson(
      response.data ?? <String, dynamic>{},
    );
  }

  @override
  Future<CheckoutPromoResultDto> removePromoCode() async {
    await _clearCheckoutSummaryCache();

    final response = await _dio.delete<Map<String, dynamic>>(
      _promoCodeEndpoint,
      options: _noCacheOptions(),
    );

    await _clearCheckoutSummaryCache();

    return CheckoutPromoResultDto.fromJson(
      response.data ?? <String, dynamic>{},
    );
  }

  @override
  Future<PlaceOrderResponseDto> placeOrder(PlaceOrderRequestDto request) async {
    await _clearCheckoutSummaryCache();

    final response = await _dio.post<Map<String, dynamic>>(
      _placeOrderEndpoint,
      data: request.toJson(),
      options: _noCacheOptions(),
    );

    await _clearCheckoutSummaryCache();

    return PlaceOrderResponseDto.fromJson(response.data ?? <String, dynamic>{});
  }
}
