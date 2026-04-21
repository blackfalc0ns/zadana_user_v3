import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';
import 'package:zadana_user_v3/feature/track_order/domain/repo/track_order_repository.dart';

@injectable
class GetOrderTrackingUseCase {
  const GetOrderTrackingUseCase(this._repository);

  final TrackOrderRepository _repository;

  Stream<ApiResult<OrderTrackingEntity>> call(String orderId) {
    return _repository.watchOrderTracking(orderId);
  }
}
