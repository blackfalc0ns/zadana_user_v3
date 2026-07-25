import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/signalr_diagnostics.dart';
import 'package:zadana_user_v3/feature/track_order/data/data_source/track_order_remote_data_source.dart';
import 'package:zadana_user_v3/feature/track_order/data/models/driver_arrival_state_changed_realtime_payload.dart';
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
    SignalRDiagnostics.instance.currentOrderId = orderId;
    SignalRDiagnostics.instance.add('TrackOrderRepository started tracking', {
      'currentOrderId': orderId,
    });
    late final StreamController<ApiResult<OrderTrackingEntity>> controller;
    StreamSubscription<OrderStatusChangedRealtimePayload>? realtimeSubscription;
    StreamSubscription<DriverArrivalStateChangedRealtimePayload>?
    driverArrivalSubscription;
    var isDisposed = false;
    var isRefreshingFromRealtime = false;
    OrderTrackingEntity? currentTracking;
    final pendingStatusEvents = <OrderStatusChangedRealtimePayload>[];
    final pendingDriverArrivalEvents =
        <DriverArrivalStateChangedRealtimePayload>[];

    Future<void> dispose() async {
      if (isDisposed) return;
      isDisposed = true;
      await realtimeSubscription?.cancel();
      await driverArrivalSubscription?.cancel();
      if (!controller.isClosed) {
        await controller.close();
      }
    }

    Future<void> fetchInitialTracking() async {
      if (isDisposed) return;
      final result = await _fetchTrackingSnapshot(orderId);
      if (isDisposed || controller.isClosed) return;

      controller.add(result);

      if (result case ApiSuccessResult<OrderTrackingEntity>()) {
        currentTracking = result.data;
        _drainPendingRealtimeEvents(
          requestedOrderId: orderId,
          currentTracking: () => currentTracking,
          updateTracking: (nextTracking) => currentTracking = nextTracking,
          pendingStatusEvents: pendingStatusEvents,
          pendingDriverArrivalEvents: pendingDriverArrivalEvents,
          emitTracking: (nextTracking) {
            controller.add(
              ApiSuccessResult<OrderTrackingEntity>(data: nextTracking),
            );
          },
        );
      }
    }

    Future<void> refreshTrackingFromRealtime() async {
      if (isDisposed || controller.isClosed || isRefreshingFromRealtime) return;
      isRefreshingFromRealtime = true;
      try {
        SignalRDiagnostics.instance.add(
          'TrackOrderRepository REST refresh started',
          {'currentOrderId': orderId, 'restSnapshotRefreshed': false},
        );
        final result = await _fetchTrackingSnapshot(orderId);
        if (isDisposed || controller.isClosed) return;
        if (result case ApiSuccessResult<OrderTrackingEntity>()) {
          // A status SignalR event arrives before the read replica serving the
          // tracking endpoint has necessarily caught up. Keep the realtime
          // state while the snapshot is older or contains no newer progress;
          // otherwise completed checkmarks can flicker and the whole screen
          // rebuilds unnecessarily.
          final snapshot = result.data;
          final current = currentTracking;
          final shouldKeepRealtimeState =
              current != null &&
              snapshot.order.status.isActive &&
              snapshot.order.status == current.order.status &&
              _visualProgress(snapshot) <= _visualProgress(current);
          final nextTracking = shouldKeepRealtimeState ? current : snapshot;
          currentTracking = nextTracking;
          // The realtime entity is already on screen; emitting it again would
          // cause an unnecessary full screen rebuild.
          if (!identical(nextTracking, current)) {
            controller.add(
              ApiSuccessResult<OrderTrackingEntity>(data: nextTracking),
            );
          }
        } else {
          controller.add(result);
        }
        SignalRDiagnostics.instance
            .add('TrackOrderRepository REST refresh completed', {
              'currentOrderId': orderId,
              'restSnapshotRefreshed':
                  result is ApiSuccessResult<OrderTrackingEntity>,
            });
      } finally {
        isRefreshingFromRealtime = false;
      }
    }

    controller = StreamController<ApiResult<OrderTrackingEntity>>(
      onListen: () {
        realtimeSubscription = _trackOrderSignalRService
            .watchOrderStatusChangedEvents()
            .listen((payload) {
              final accepted = _matchesStatusPayload(
                requestedOrderId: orderId,
                payload: payload,
                tracking: currentTracking,
              );
              SignalRDiagnostics.instance
                  .add('TrackOrderRepository status event decision', {
                    'currentOrderId': orderId,
                    'incomingOrderId': payload.orderId,
                    'eventAccepted': accepted,
                    if (!accepted)
                      'discardReason':
                          'Incoming orderId did not match the tracked order.',
                  });
              if (!accepted) {
                return;
              }

              final tracking = currentTracking;
              if (tracking == null || controller.isClosed) {
                SignalRDiagnostics.instance
                    .add('TrackOrderRepository status event queued', {
                      'currentOrderId': orderId,
                      'incomingOrderId': payload.orderId,
                      'eventAccepted': true,
                    });
                pendingStatusEvents.add(payload);
                return;
              }

              currentTracking = _applyRealtimeStatusChange(tracking, payload);
              controller.add(
                ApiSuccessResult<OrderTrackingEntity>(data: currentTracking!),
              );
              SignalRDiagnostics.instance
                  .add('TrackOrderRepository emitted realtime state', {
                    'currentOrderId': orderId,
                    'incomingOrderId': payload.orderId,
                    'eventAccepted': true,
                  });
              unawaited(refreshTrackingFromRealtime());
            });

        driverArrivalSubscription = _trackOrderSignalRService
            .watchDriverArrivalStateChangedEvents()
            .listen((payload) {
              if (!_matchesDriverArrivalPayload(
                requestedOrderId: orderId,
                payload: payload,
                tracking: currentTracking,
              )) {
                return;
              }

              final tracking = currentTracking;
              if (tracking?.isPickup ?? false) {
                SignalRDiagnostics.instance.add(
                  'TrackOrderRepository ignored driver arrival for pickup',
                  {
                    'currentOrderId': orderId,
                    'incomingOrderId': payload.orderId,
                  },
                );
                return;
              }
              if (tracking == null || controller.isClosed) {
                pendingDriverArrivalEvents.add(payload);
                return;
              }

              currentTracking = _applyDriverArrivalChange(tracking, payload);
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

  @override
  Future<ApiResult<void>> resendPickupOtp(String orderId) {
    return safeApiCall(() => _remoteDataSource.resendPickupOtp(orderId));
  }

  Future<ApiResult<OrderTrackingEntity>> _fetchTrackingSnapshot(
    String orderId,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getOrderTracking(orderId);
      return response.toEntity();
    });
  }

  OrderTrackingEntity _applyRealtimeStatusChange(
    OrderTrackingEntity current,
    OrderStatusChangedRealtimePayload payload,
  ) {
    final nextStatus = OrderStatus.fromApi(payload.newStatus);
    final pickupBranch = payload.pickupBranch;
    final shouldClearPickupOtp =
        payload.isPickup &&
        (nextStatus == OrderStatus.delivered ||
            nextStatus.isCancelled ||
            payload.pickupOtpCode == null);
    if (nextStatus.isCancelled || nextStatus.isReturning) {
      return current.copyWith(
        order: current.order.copyWith(status: nextStatus),
        fulfillmentType: payload.isPickup ? 'pickup' : current.fulfillmentType,
        pickupOtpCode: payload.pickupOtpCode,
        pickupOtpExpiresAtUtc: payload.pickupOtpExpiresAtUtc,
        pickupNoShowDeadlineUtc: payload.pickupNoShowDeadlineUtc,
        pickupBranch: pickupBranch == null
            ? null
            : OrderPickupBranchEntity(
                name: pickupBranch.name,
                address: pickupBranch.address,
                hoursToday: pickupBranch.hoursToday,
              ),
        clearPickupOtp: shouldClearPickupOtp,
        clearPickupOtpExpiresAtUtc: shouldClearPickupOtp,
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
          // The API distinguishes a completed step from the current one.
          // This matters for pickup orders: `ready_for_pickup` is the next
          // active step, not another alias for `preparing`.
          final isCurrentStep = itemStageIndex == currentStageIndex;
          final isCompletedStep = itemStageIndex < currentStageIndex;
          final shouldStampTime =
              realtimeTime.isNotEmpty &&
              itemStageIndex == currentStageIndex &&
              item.time.trim().isEmpty;

          return item.copyWith(
            isActive: isCurrentStep,
            isCompleted: isCompletedStep,
            time: shouldStampTime ? realtimeTime : item.time,
          );
        })
        .toList(growable: false);

    return current.copyWith(
      order: current.order.copyWith(status: nextStatus),
      fulfillmentType: payload.isPickup ? 'pickup' : current.fulfillmentType,
      pickupOtpCode: payload.pickupOtpCode,
      pickupOtpExpiresAtUtc: payload.pickupOtpExpiresAtUtc,
      pickupNoShowDeadlineUtc: payload.pickupNoShowDeadlineUtc,
      pickupBranch: pickupBranch == null
          ? null
          : OrderPickupBranchEntity(
              name: pickupBranch.name,
              address: pickupBranch.address,
              hoursToday: pickupBranch.hoursToday,
            ),
      clearPickupOtp: shouldClearPickupOtp,
      clearPickupOtpExpiresAtUtc: shouldClearPickupOtp,
      timeline: updatedTimeline,
    );
  }

  OrderTrackingEntity _applyDriverArrivalChange(
    OrderTrackingEntity current,
    DriverArrivalStateChangedRealtimePayload payload,
  ) {
    final arrivalState = DriverArrivalState.fromApi(payload.arrivalState);
    if (arrivalState == null) {
      return current;
    }

    final normalizedDriverName = payload.driverName?.trim() ?? '';
    final updatedDriver = normalizedDriverName.isEmpty
        ? current.driver
        : (current.driver?.copyWith(name: normalizedDriverName) ??
              OrderTrackingDriverEntity(
                id: '',
                name: normalizedDriverName,
                phoneNumber: '',
                subtitle: '',
              ));
    final updatedAssignedDriver = normalizedDriverName.isEmpty
        ? current.assignedDriver
        : (current.assignedDriver?.copyWith(name: normalizedDriverName) ??
              OrderTrackingAssignedDriverEntity(
                id: '',
                name: normalizedDriverName,
                phoneNumber: '',
                vehicleType: '',
                plateNumber: '',
              ));

    return current.copyWith(
      driver: updatedDriver,
      assignedDriver: updatedAssignedDriver,
      driverArrivalState: arrivalState,
      driverArrivalUpdatedAtUtc: payload.changedAtUtc,
      showDeliveryOtp:
          arrivalState == DriverArrivalState.arrivedAtCustomer ||
          current.showDeliveryOtp,
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
      case 'ready_for_pickup':
      case 'readyforpickup':
        return 3;
      case 'driver_assigned':
      case 'driverassigned':
      case 'on_the_way':
      case 'ontheway':
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

  /// Returns the furthest step displayed in the timeline.
  ///
  /// `processing` covers both vendor-confirmed and preparing in the API, so
  /// comparing the order status alone cannot identify an older snapshot.
  int _visualProgress(OrderTrackingEntity tracking) {
    var progress = -1;
    for (var index = 0; index < tracking.timeline.length; index++) {
      final item = tracking.timeline[index];
      if (item.isActive || item.isCompleted) {
        progress = _stageIndexFromTimelineItem(item, index);
      }
    }
    if (progress >= 0) return progress;

    return _stageIndexFromRawStatus(tracking.order.status.name);
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

  void _drainPendingRealtimeEvents({
    required String requestedOrderId,
    required OrderTrackingEntity? Function() currentTracking,
    required void Function(OrderTrackingEntity nextTracking) updateTracking,
    required List<OrderStatusChangedRealtimePayload> pendingStatusEvents,
    required List<DriverArrivalStateChangedRealtimePayload>
    pendingDriverArrivalEvents,
    required void Function(OrderTrackingEntity nextTracking) emitTracking,
  }) {
    final statusEvents = List<OrderStatusChangedRealtimePayload>.from(
      pendingStatusEvents,
    );
    pendingStatusEvents.clear();

    for (final payload in statusEvents) {
      final tracking = currentTracking();
      if (tracking == null ||
          !_matchesStatusPayload(
            requestedOrderId: requestedOrderId,
            payload: payload,
            tracking: tracking,
          )) {
        continue;
      }

      final nextTracking = _applyRealtimeStatusChange(tracking, payload);
      updateTracking(nextTracking);
      emitTracking(nextTracking);
    }

    final driverArrivalEvents =
        List<DriverArrivalStateChangedRealtimePayload>.from(
          pendingDriverArrivalEvents,
        );
    pendingDriverArrivalEvents.clear();

    for (final payload in driverArrivalEvents) {
      final tracking = currentTracking();
      if (tracking == null ||
          !_matchesDriverArrivalPayload(
            requestedOrderId: requestedOrderId,
            payload: payload,
            tracking: tracking,
          ) ||
          tracking.isPickup) {
        continue;
      }

      final nextTracking = _applyDriverArrivalChange(tracking, payload);
      updateTracking(nextTracking);
      emitTracking(nextTracking);
    }
  }

  bool _matchesStatusPayload({
    required String requestedOrderId,
    required OrderStatusChangedRealtimePayload payload,
    required OrderTrackingEntity? tracking,
  }) {
    return _matchesKnownOrderIdentifiers(
      requestedOrderId: requestedOrderId,
      trackedOrderId: tracking?.order.id,
      payloadOrderId: payload.orderId,
      payloadOrderNumber: payload.orderNumber,
    );
  }

  bool _matchesDriverArrivalPayload({
    required String requestedOrderId,
    required DriverArrivalStateChangedRealtimePayload payload,
    required OrderTrackingEntity? tracking,
  }) {
    return _matchesKnownOrderIdentifiers(
      requestedOrderId: requestedOrderId,
      trackedOrderId: tracking?.order.id,
      payloadOrderId: payload.orderId,
      payloadOrderNumber: payload.orderNumber,
    );
  }

  bool _matchesKnownOrderIdentifiers({
    required String requestedOrderId,
    required String payloadOrderId,
    required String? payloadOrderNumber,
    String? trackedOrderId,
  }) {
    final knownIds = <String>{
      _normalizeOrderId(requestedOrderId),
      _normalizeOrderId(trackedOrderId ?? ''),
    }..removeWhere((value) => value.isEmpty);

    final incomingIds = <String>{
      _normalizeOrderId(payloadOrderId),
      _normalizeOrderId(payloadOrderNumber ?? ''),
    }..removeWhere((value) => value.isEmpty);

    return knownIds.any(incomingIds.contains);
  }

  String _normalizeOrderId(String value) => value.trim().toLowerCase();
}
