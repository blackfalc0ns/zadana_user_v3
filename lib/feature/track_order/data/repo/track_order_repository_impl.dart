import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/track_order/data/data_source/track_order_remote_data_source.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';
import 'package:zadana_user_v3/feature/track_order/domain/repo/track_order_repository.dart';

@Injectable(as: TrackOrderRepository)
class TrackOrderRepositoryImpl implements TrackOrderRepository {
  const TrackOrderRepositoryImpl(this._remoteDataSource);

  static const Duration _pollingInterval = Duration(seconds: 10);

  final TrackOrderRemoteDataSource _remoteDataSource;

  @override
  Stream<ApiResult<OrderTrackingEntity>> watchOrderTracking(
    String orderId,
  ) async* {
    while (true) {
      try {
        final response = await _remoteDataSource.getOrderTracking(orderId);
        final entity = response.toEntity();
        yield ApiSuccessResult<OrderTrackingEntity>(data: entity);

        if (!entity.order.status.isActive) {
          break;
        }
      } on DioException catch (error) {
        yield ApiErrorResult<OrderTrackingEntity>(
          failure: ServerFailure.fromDioError(dioException: error),
        );
      } catch (_) {
        yield ApiErrorResult<OrderTrackingEntity>(
          failure: const Failure(errorMessage: 'Unexpected error occurred.'),
        );
      }

      await Future<void>.delayed(_pollingInterval);
    }
  }
}
