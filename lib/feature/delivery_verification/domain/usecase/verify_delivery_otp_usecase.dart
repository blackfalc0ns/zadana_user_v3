import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../repo/delivery_verification_repo.dart';

@injectable
class VerifyDeliveryOtpUseCase {
  VerifyDeliveryOtpUseCase(this.repository);
  final DeliveryVerificationRepo repository;

  Future<ApiResult<bool>> call(String orderId, String otpCode) {
    return repository.verifyOtp(orderId, otpCode);
  }
}
