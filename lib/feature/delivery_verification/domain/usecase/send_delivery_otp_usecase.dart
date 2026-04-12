import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../repo/delivery_verification_repo.dart';

@injectable
class SendDeliveryOtpUseCase {
  final DeliveryVerificationRepo repository;

  SendDeliveryOtpUseCase(this.repository);

  Future<ApiResult<void>> call(String orderId, String phoneNumber) {
    return repository.sendOtp(orderId, phoneNumber);
  }
}