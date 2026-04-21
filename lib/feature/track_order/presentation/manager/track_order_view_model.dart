import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';
import 'package:zadana_user_v3/feature/track_order/domain/usecase/get_order_tracking_usecase.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/manager/track_order_state.dart';

@injectable
class TrackOrderViewModel extends Cubit<TrackOrderState> {
  TrackOrderViewModel(this._getOrderTrackingUseCase)
    : super(const TrackOrderState());

  final GetOrderTrackingUseCase _getOrderTrackingUseCase;

  StreamSubscription<ApiResult<OrderTrackingEntity>>? _trackingSubscription;
  String? _orderId;

  void initialize(String orderId) {
    _orderId = orderId;
    load();
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
      case ApiErrorResult<OrderTrackingEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            isLive: false,
            failure: result.failure,
          ),
        );
    }
  }

  @override
  Future<void> close() {
    _stopStreaming();
    return super.close();
  }
}
