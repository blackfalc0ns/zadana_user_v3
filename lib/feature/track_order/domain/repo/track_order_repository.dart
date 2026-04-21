import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';

abstract class TrackOrderRepository {
  Stream<ApiResult<OrderTrackingEntity>> watchOrderTracking(String orderId);
}
