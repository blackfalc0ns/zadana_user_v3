import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/verify_reset_otp_response_entity.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/repo/reset_password_repository.dart';

@injectable
class VerifyResetOtpUseCase {
  VerifyResetOtpUseCase({required this.repository});
  final ResetPasswordRepository repository;

  Future<ApiResult<VerifyResetOtpResponseEntity>> call({
    required String identifier,
    required String otpCode,
  }) async {
    return await repository.verifyResetOtp(
      identifier: identifier,
      otpCode: otpCode,
    );
  }
}
