import 'package:zadana_user_v3/core/network/api_results.dart';
import '../entities/verify_otp_request_entity.dart';
import '../entities/verify_otp_response_entity.dart';

/// Verify OTP repository contract
/// Domain layer - Abstract interface
abstract class VerifyOtpRepository {
  Future<ApiResult<VerifyOtpResponseEntity>> verifyOtp(
    VerifyOtpRequestEntity request,
  );

  Future<ApiResult<void>> resendOtp(String identifier);

  Future<ApiResult<void>> resendResetOtp(String identifier);
}
