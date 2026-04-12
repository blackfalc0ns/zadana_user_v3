import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../repo/delivery_verification_repo.dart';

@injectable
class ResendDeliveryOtpUseCase {
  final DeliveryVerificationRepo repository;

  ResendDeliveryOtpUseCase(this.repository);

  Future<ApiResult<void>> call(String orderId) {
    return repository.resendOtp(orderId);
  }
}