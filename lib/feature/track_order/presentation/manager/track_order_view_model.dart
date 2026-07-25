import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/signalr_diagnostics.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';
import 'package:zadana_user_v3/feature/track_order/domain/usecase/get_order_tracking_usecase.dart';
import 'package:zadana_user_v3/feature/track_order/domain/usecase/resend_pickup_otp_usecase.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/manager/track_order_state.dart';

@injectable
class TrackOrderViewModel extends Cubit<TrackOrderState> {
  TrackOrderViewModel(
    this._getOrderTrackingUseCase,
    this._resendPickupOtpUseCase,
  ) : super(const TrackOrderState());

  final GetOrderTrackingUseCase _getOrderTrackingUseCase;
  final ResendPickupOtpUseCase _resendPickupOtpUseCase;

  StreamSubscription<ApiResult<OrderTrackingEntity>>? _trackingSubscription;
  StreamSubscription<dynamic>? _supportCaseChangedSubscription;
  String? _orderId;

  void initialize(String orderId) {
    _orderId = orderId;
    SignalRDiagnostics.instance.currentOrderId = orderId;
    _bindSupportCaseRealtime();
    load();
  }

  void refresh() => load(isManualRefresh: true);

  Future<bool> resendPickupOtp() async {
    final orderId = _orderId;
    if (orderId == null || orderId.isEmpty || state.isResendingPickupOtp) {
      return false;
    }

    emit(state.copyWith(isResendingPickupOtp: true, clearFailure: true));
    final result = await _resendPickupOtpUseCase(orderId);
    switch (result) {
      case ApiSuccessResult<void>():
        emit(state.copyWith(isResendingPickupOtp: false));
        refresh();
        return true;
      case ApiErrorResult<void>():
        emit(
          state.copyWith(isResendingPickupOtp: false, failure: result.failure),
        );
        return false;
    }
  }

  void load({bool isManualRefresh = false}) {
    final orderId = _orderId;
    if (orderId == null || orderId.isEmpty) return;

    emit(
      state.copyWith(
        isLoading: state.orderTracking == null && !isManualRefresh,
        isRefreshing: state.orderTracking != null || isManualRefresh,
        clearFailure: true,
      ),
    );

    _subscribe();
  }

  NotificationsSignalRService get _notificationsSignalRService =>
      GetIt.instance<NotificationsSignalRService>();

  void _bindSupportCaseRealtime() {
    _supportCaseChangedSubscription ??= _notificationsSignalRService
        .watchOrderSupportCaseChangedEvents()
        .listen((payload) {
          if (payload.orderId.trim().toLowerCase() !=
              (_orderId ?? '').trim().toLowerCase()) {
            return;
          }
          refresh();
        });
  }

  void _subscribe() {
    final orderId = _orderId;
    if (orderId == null || orderId.isEmpty) return;

    _trackingSubscription?.cancel();
    _trackingSubscription = _getOrderTrackingUseCase(
      orderId,
    ).listen(_applyResult);
  }

  void _stopStreaming() {
    _trackingSubscription?.cancel();
    _trackingSubscription = null;
  }

  void _applyResult(ApiResult<OrderTrackingEntity> result) {
    switch (result) {
      case ApiSuccessResult<OrderTrackingEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            orderTracking: result.data,
            isLive: result.data.order.status.isActive,
            lastUpdatedAt: DateTime.now(),
            clearFailure: true,
          ),
        );
        SignalRDiagnostics.instance
            .add('TrackOrderViewModel emitted new state', {
              'currentOrderId': _orderId,
              'viewModelEmittedNewState': true,
              'trackedOrderId': result.data.order.id,
            });
      case ApiErrorResult<OrderTrackingEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            isLive: false,
            failure: result.failure,
          ),
        );
        SignalRDiagnostics.instance.add('TrackOrderViewModel state failure', {
          'currentOrderId': _orderId,
          'viewModelEmittedNewState': true,
          'exception': result.failure.toString(),
        });
    }
  }

  String localizedTimelineTitle(
    AppLocalizations l10n,
    OrderTrackingTimelineItemEntity item,
    int index,
  ) {
    switch (item.id) {
      case 'order_placed':
        return l10n.track_order_order_placed;
      case 'vendor_confirmed':
        return item.isActive && !item.isCompleted
            ? l10n.track_order_waiting_vendor_confirmation
            : l10n.track_order_vendor_confirmed;
      case 'preparing':
        return l10n.track_order_preparing;
      case 'out_for_delivery':
        return l10n.track_order_out_for_delivery;
      case 'ready_for_pickup':
      case 'readyforpickup':
        return l10n.localeName.startsWith('ar')
            ? 'جاهز للاستلام من الفرع'
            : 'Ready for pickup';
      case 'delivered':
        return l10n.order_delivered;
      default:
        final title = item.title.trim();
        return title.isNotEmpty ? title : _timelineFallbackLabel(l10n, index);
    }
  }

  String resolveEstimatedDeliveryText({
    required AppLocalizations l10n,
    required String localeCode,
    required OrderEstimatedDeliveryEntity? estimatedDelivery,
  }) {
    if (estimatedDelivery == null) {
      return l10n.order_pending;
    }

    final dateTime = estimatedDelivery.dateTime;
    if (dateTime != null) {
      return DateFormat(
        'dd MMM yyyy, hh:mm a',
        localeCode,
      ).format(dateTime.toLocal());
    }

    final formatted = estimatedDelivery.formatted.trim();
    return formatted.isNotEmpty ? formatted : l10n.order_pending;
  }

  String sanitizeTimelineTime(String value) => value.trim();

  String? resolveDriverArrivalStateLabel(
    AppLocalizations l10n,
    DriverArrivalState? arrivalState,
  ) {
    switch (arrivalState) {
      case DriverArrivalState.enRoute:
        return l10n.track_order_out_for_delivery;
      case DriverArrivalState.arrivedAtVendor:
        return l10n.track_order_vendor_confirmed;
      case DriverArrivalState.arrivedAtCustomer:
        return l10n.order_delivered;
      case null:
        return null;
    }
  }

  String _timelineFallbackLabel(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.order_pending;
      case 1:
        return l10n.track_order;
      case 2:
        return l10n.delivery_get_otp;
      default:
        return l10n.order_delivered;
    }
  }

  @override
  Future<void> close() async {
    _stopStreaming();
    await _supportCaseChangedSubscription?.cancel();
    return super.close();
  }
}
