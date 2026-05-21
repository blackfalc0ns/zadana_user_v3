import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../repo/verify_otp_repository.dart';

/// Resend OTP use case
/// Domain layer - Business logic
@injectable
class ResendOtpUseCase {
  const ResendOtpUseCase(this._repository);
  final VerifyOtpRepository _repository;

  Future<ApiResult<void>> call(String identifier) async {
    return await _repository.resendOtp(identifier);
  }
}
