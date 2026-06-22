import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/reset_password_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/reset_password_response_entity.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/verify_reset_otp_response_entity.dart';

abstract class ResetPasswordRepository {
  Future<ApiResult<VerifyResetOtpResponseEntity>> verifyResetOtp({
    required String identifier,
    required String otpCode,
  });

  Future<ApiResult<ResetPasswordResponseEntity>> resetPassword(
    ResetPasswordRequestEntity entity,
  );
}
