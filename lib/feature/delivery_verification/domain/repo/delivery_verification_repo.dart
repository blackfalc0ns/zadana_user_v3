import 'package:zadana_user_v3/core/network/api_results.dart';

abstract class DeliveryVerificationRepo {
  Future<ApiResult<void>> sendOtp(String orderId, String phoneNumber);
  Future<ApiResult<bool>> verifyOtp(String orderId, String otpCode);
  Future<ApiResult<void>> resendOtp(String orderId);
}
