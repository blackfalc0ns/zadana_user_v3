import '../models/resend_otp_request_model_dto.dart';
import '../models/verify_otp_request_model_dto.dart';
import '../models/verify_otp_response_model_dto.dart';

/// Verify OTP remote data source contract
/// Data layer - API interface
abstract class VerifyOtpRemoteDataSource {
  Future<VerifyOtpResponseModelDto> verifyOtp(VerifyOtpRequestModelDto request);
  Future<void> resendOtp(ResendOtpRequestModelDto request);
  Future<void> resendResetOtp(ResendOtpRequestModelDto request);
}
