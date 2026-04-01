import 'package:zadana_user_v3/feature/delivery_verification/data/models/delivery_otp_request_model.dart';
import 'package:zadana_user_v3/feature/delivery_verification/data/models/delivery_otp_response_model.dart';

/// Delivery Verification remote data source contract
/// Data layer - API interface
abstract class DeliveryVerificationRemoteDataSource {
  Future<void> sendOtp(DeliveryOtpRequestModel request);
  Future<DeliveryOtpResponseModel> verifyOtp(DeliveryOtpRequestModel request);
  Future<void> resendOtp(DeliveryOtpRequestModel request);
}