import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/track_order/data/data_source/track_order_remote_data_source.dart';
import 'package:zadana_user_v3/feature/track_order/data/models/order_tracking_response_dto.dart';

@Injectable(as: TrackOrderRemoteDataSource)
class TrackOrderRemoteDataSourceImpl implements TrackOrderRemoteDataSource {
  const TrackOrderRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<OrderTrackingResponseDto> getOrderTracking(String orderId) {
    return _apiServices.getOrderTracking(orderId);
  }

  @override
  Future<void> resendPickupOtp(String orderId) {
    return _apiServices.resendPickupOtp(orderId);
  }
}
