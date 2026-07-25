import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';

class TrackOrderState {
  const TrackOrderState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isResendingPickupOtp = false,
    this.isLive = false,
    this.orderTracking,
    this.failure,
    this.lastUpdatedAt,
  });

  final bool isLoading;
  final bool isRefreshing;
  final bool isResendingPickupOtp;
  final bool isLive;
  final OrderTrackingEntity? orderTracking;
  final Failure? failure;
  final DateTime? lastUpdatedAt;

  TrackOrderState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isResendingPickupOtp,
    bool? isLive,
    OrderTrackingEntity? orderTracking,
    Failure? failure,
    DateTime? lastUpdatedAt,
    bool clearFailure = false,
  }) {
    return TrackOrderState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isResendingPickupOtp: isResendingPickupOtp ?? this.isResendingPickupOtp,
      isLive: isLive ?? this.isLive,
      orderTracking: orderTracking ?? this.orderTracking,
      failure: clearFailure ? null : failure ?? this.failure,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
