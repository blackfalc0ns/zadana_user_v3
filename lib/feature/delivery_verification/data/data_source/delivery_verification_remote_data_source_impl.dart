import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/delivery_verification/data/models/delivery_otp_request_model.dart';
import 'package:zadana_user_v3/feature/delivery_verification/data/models/delivery_otp_response_model.dart';
import 'delivery_verification_remote_data_source.dart';

/// Delivery Verification remote data source implementation
/// Data layer - API implementation using Retrofit
@Injectable(as: DeliveryVerificationRemoteDataSource)
class DeliveryVerificationRemoteDataSourceImpl
    implements DeliveryVerificationRemoteDataSource {
  final ApiServices _apiServices;

  DeliveryVerificationRemoteDataSourceImpl(this._apiServices);

  @override
  Future<void> sendOtp(DeliveryOtpRequestModel request) async {
    await _apiServices.sendDeliveryOtp(request);
  }

  @override
  Future<DeliveryOtpResponseModel> verifyOtp(
      DeliveryOtpRequestModel request) async {
    return _apiServices.verifyDeliveryOtp(request);
  }

  @override
  Future<void> resendOtp(DeliveryOtpRequestModel request) async {
    await _apiServices.resendDeliveryOtp(request);
  }
}