import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';
import 'package:zadana_user_v3/feature/track_order/data/models/driver_arrival_state_changed_realtime_payload.dart';
import 'package:zadana_user_v3/feature/track_order/data/models/order_status_changed_realtime_payload.dart';

@lazySingleton
class TrackOrderSignalRService {
  TrackOrderSignalRService(this._tokenService);

  final TokenService _tokenService;
  NotificationsSignalRService get _notificationsSignalRService =>
      GetIt.instance<NotificationsSignalRService>();

  Stream<OrderStatusChangedRealtimePayload> watchOrderStatusChangedEvents() {
    unawaited(_tokenService.getToken());
    return _notificationsSignalRService.watchOrderStatusChangedEvents();
  }

  Stream<DriverArrivalStateChangedRealtimePayload>
  watchDriverArrivalStateChangedEvents() {
    unawaited(_tokenService.getToken());
    return _notificationsSignalRService.watchDriverArrivalStateChangedEvents();
  }
}
