import 'package:zadana_user_v3/feature/auth/reset_password/data/models/request/reset_password_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/models/request/verify_reset_otp_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/models/response/reset_password_response_dto.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/models/response/verify_reset_otp_response_dto.dart';

abstract class ResetPasswordRemoteDataSource {
  Future<VerifyResetOtpResponseDto> verifyResetOtp(
    VerifyResetOtpRequestDto requestDto,
  );

  Future<ResetPasswordResponseDto> resetPassword(
    ResetPasswordRequestDto requestDto,
  );
}
