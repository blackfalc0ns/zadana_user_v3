import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../entities/verify_otp_request_entity.dart';
import '../entities/verify_otp_response_entity.dart';
import '../repo/verify_otp_repository.dart';

/// Verify OTP use case
/// Domain layer - Business logic
@injectable
class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);
  final VerifyOtpRepository _repository;

  Future<ApiResult<VerifyOtpResponseEntity>> call(
    VerifyOtpRequestEntity request,
  ) async {
    return await _repository.verifyOtp(request);
  }
}
