import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';
import 'package:zadana_user_v3/feature/track_order/data/data_source/track_order_remote_data_source.dart';
import 'package:zadana_user_v3/feature/track_order/data/models/order_status_changed_realtime_payload.dart';
import 'package:zadana_user_v3/feature/track_order/data/services/track_order_signalr_service.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';
import 'package:zadana_user_v3/feature/track_order/domain/repo/track_order_repository.dart';

@Injectable(as: TrackOrderRepository)
class TrackOrderRepositoryImpl implements TrackOrderRepository {
  const TrackOrderRepositoryImpl(
    this._remoteDataSource,
    this._trackOrderSignalRService,
  );

  final TrackOrderRemoteDataSource _remoteDataSource;
  final TrackOrderSignalRService _trackOrderSignalRService;

  @override
  Stream<ApiResult<OrderTrackingEntity>> watchOrderTracking(String orderId) {
    late final StreamController<ApiResult<OrderTrackingEntity>> controller;
    StreamSubscription<OrderStatusChangedRealtimePayload>? realtimeSubscription;
    var isDisposed = false;
    OrderTrackingEntity? currentTracking;

    Future<void> dispose() async {
      if (isDisposed) return;
      isDisposed = true;
      await realtimeSubscription?.cancel();
      if (!controller.isClosed) {
        await controller.close();
      }
    }

    Future<void> fetchInitialTracking() async {
      if (isDisposed) return;
      final result = await safeApiCall(() async {
        final response = await _remoteDataSource.getOrderTracking(orderId);
        return response.toEntity();
      });

      if (isDisposed || controller.isClosed) return;

      controller.add(result);

      if (result case ApiSuccessResult<OrderTrackingEntity>()) {
        currentTracking = result.data;
      }
    }

    controller = StreamController<ApiResult<OrderTrackingEntity>>(
      onListen: () {
        realtimeSubscription = _trackOrderSignalRService
            .watchOrderStatusChangedEvents()
            .where((payload) => payload.orderId == orderId)
            .listen((payload) {
              final tracking = currentTracking;
              if (tracking == null || controller.isClosed) return;

              currentTracking = _applyRealtimeStatusChange(tracking, payload);
              controller.add(
                ApiSuccessResult<OrderTrackingEntity>(data: currentTracking!),
              );
            });

        unawaited(fetchInitialTracking());
      },
      onCancel: () async {
        await dispose();
      },
    );

    return controller.stream;
  }

  OrderTrackingEntity _applyRealtimeStatusChange(
    OrderTrackingEntity current,
    OrderStatusChangedRealtimePayload payload,
  ) {
    final nextStatus = OrderStatus.fromApi(payload.newStatus);
    if (nextStatus.isCancelled || nextStatus.isReturning) {
      return current.copyWith(
        order: current.order.copyWith(status: nextStatus),
      );
    }

    final currentStageIndex = _stageIndexFromRawStatus(payload.newStatus);
    final realtimeTime = _formatRealtimeTime(payload.changedAtUtc);

    final updatedTimeline = current.timeline
        .asMap()
        .entries
        .map((entry) {
          final item = entry.value;
          final itemStageIndex = _stageIndexFromTimelineItem(item, entry.key);
          final isReached = itemStageIndex <= currentStageIndex;
          final shouldStampTime =
              realtimeTime.isNotEmpty &&
              itemStageIndex == currentStageIndex &&
              item.time.trim().isEmpty;

          return item.copyWith(
            isActive: isReached,
            isCompleted: isReached,
            time: shouldStampTime ? realtimeTime : item.time,
          );
        })
        .toList(growable: false);

    return current.copyWith(
      order: current.order.copyWith(status: nextStatus),
      timeline: updatedTimeline,
    );
  }

  int _stageIndexFromRawStatus(String status) {
    switch (status.trim().toLowerCase()) {
      case 'pending':
      case 'pendingvendoracceptance':
      case 'order_placed':
        return 0;
      case 'accepted':
      case 'vendor_confirmed':
        return 1;
      case 'preparing':
      case 'processing':
        return 2;
      case 'out_for_delivery':
      case 'outfordelivery':
      case 'shipped':
        return 3;
      case 'delivered':
      case 'completed':
        return 4;
      default:
        return 0;
    }
  }

  int _stageIndexFromTimelineItem(
    OrderTrackingTimelineItemEntity item,
    int fallbackIndex,
  ) {
    switch (item.id.trim().toLowerCase()) {
      case 'order_placed':
        return 0;
      case 'vendor_confirmed':
        return 1;
      case 'preparing':
        return 2;
      case 'out_for_delivery':
        return 3;
      case 'delivered':
        return 4;
      default:
        return fallbackIndex;
    }
  }

  String _formatRealtimeTime(DateTime? changedAtUtc) {
    if (changedAtUtc == null) return '';
    return DateFormat('yyyy-MM-dd HH:mm').format(changedAtUtc.toLocal());
  }
}
