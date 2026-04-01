import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../repo/delivery_verification_repo.dart';

@injectable
class VerifyDeliveryOtpUseCase {
  final DeliveryVerificationRepo repository;

  VerifyDeliveryOtpUseCase(this.repository);

  Future<ApiResult<bool>> call(String orderId, String otpCode) {
    return repository.verifyOtp(orderId, otpCode);
  }
}