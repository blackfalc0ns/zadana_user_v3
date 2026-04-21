import 'package:zadana_user_v3/feature/track_order/data/models/order_tracking_response_dto.dart';

abstract class TrackOrderRemoteDataSource {
  Future<OrderTrackingResponseDto> getOrderTracking(String orderId);
}
