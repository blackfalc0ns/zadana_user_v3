import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/track_order/domain/repo/track_order_repository.dart';

@injectable
class ResendPickupOtpUseCase {
  const ResendPickupOtpUseCase(this._repository);

  final TrackOrderRepository _repository;

  Future<ApiResult<void>> call(String orderId) {
    return _repository.resendPickupOtp(orderId);
  }
}
