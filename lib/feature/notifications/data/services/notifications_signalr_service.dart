import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/core/services/notification_payload_resolver.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/app_notification_dto.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/app_notification_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_support_case_changed_realtime_payload.dart';
import 'package:zadana_user_v3/feature/track_order/data/models/driver_arrival_state_changed_realtime_payload.dart';
import 'package:zadana_user_v3/feature/track_order/data/models/order_status_changed_realtime_payload.dart';

@lazySingleton
class NotificationsSignalRService {
  NotificationsSignalRService(this._tokenService);

  final TokenService _tokenService;
  final Logger _logger = Logger();
  static const Duration _reconnectDelay = Duration(seconds: 5);
  static const Duration _heartbeatInterval = Duration(seconds: 60);
  static const int _maxTrackedNotificationIds = 200;
  final StreamController<AppNotificationEntity> _notificationsController =
      StreamController<AppNotificationEntity>.broadcast();
  final StreamController<OrderStatusChangedRealtimePayload>
  _orderStatusChangedController =
      StreamController<OrderStatusChangedRealtimePayload>.broadcast();
  final StreamController<DriverArrivalStateChangedRealtimePayload>
  _driverArrivalStateChangedController =
      StreamController<DriverArrivalStateChangedRealtimePayload>.broadcast();
  final StreamController<OrderSupportCaseChangedRealtimePayload>
  _orderSupportCaseChangedController =
      StreamController<OrderSupportCaseChangedRealtimePayload>.broadcast();
  final List<String> _recentNotificationIds = <String>[];
  final Set<String> _recentNotificationIdSet = <String>{};

  HubConnection? _connection;
  HubConnection? _presenceConnection;
  bool _isStarting = false;
  bool _isStartingPresence = false;
  bool _isReconnectScheduled = false;
  bool _isPresenceReconnectScheduled = false;
  bool _isManuallyStopped = false;
  bool _isAppInForeground = true;
  Timer? _heartbeatTimer;

  Stream<AppNotificationEntity> watchNotifications() {
    unawaited(activateAuthenticatedConnectionIfPossible());
    return _notificationsController.stream;
  }

  Stream<OrderStatusChangedRealtimePayload> watchOrderStatusChangedEvents() {
    unawaited(activateAuthenticatedConnectionIfPossible());
    return _orderStatusChangedController.stream;
  }

  Stream<DriverArrivalStateChangedRealtimePayload>
  watchDriverArrivalStateChangedEvents() {
    unawaited(activateAuthenticatedConnectionIfPossible());
    return _driverArrivalStateChangedController.stream;
  }

  Stream<OrderSupportCaseChangedRealtimePayload>
  watchOrderSupportCaseChangedEvents() {
    unawaited(activateAuthenticatedConnectionIfPossible());
    return _orderSupportCaseChangedController.stream;
  }

  Future<void> activateAuthenticatedConnectionIfPossible() async {
    _isManuallyStopped = false;
    await Future.wait<void>([_ensureConnected(), _ensurePresenceConnected()]);
    if (_isAppInForeground) {
      await notifyAppForeground();
    }
  }

  Future<void> disconnect() async {
    _isManuallyStopped = true;
    final connection = _connection;
    final presenceConnection = _presenceConnection;
    _connection = null;
    _presenceConnection = null;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;

    if (connection != null) {
      try {
        await connection.stop();
        _logger.i('Notifications SignalR disconnected.');
      } catch (error, stackTrace) {
        _logger.w(
          'Notifications SignalR disconnect failed.',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }

    if (presenceConnection != null) {
      try {
        await presenceConnection.stop();
        _logger.i('Customer presence SignalR disconnected.');
      } catch (error, stackTrace) {
        _logger.w(
          'Customer presence SignalR disconnect failed.',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Future<void> _ensureConnected() async {
    if (_isStarting) return;

    final currentConnection = _connection;
    if (currentConnection != null &&
        currentConnection.state != HubConnectionState.Disconnected) {
      return;
    }

    _isStarting = true;
    try {
      final token = await _tokenService.getToken();
      if (token == null || token.trim().isEmpty) {
        return;
      }

      final connection = HubConnectionBuilder()
          .withUrl(
            _buildHubUrl(),
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token,
            ),
          )
          .withAutomaticReconnect()
          .build();

      connection.on(
        NetworkConstants.receiveNotificationSignalREvent,
        _handleRealtimeNotification,
      );
      connection.on(
        NetworkConstants.receiveBroadcastSignalREvent,
        _handleRealtimeNotification,
      );
      connection.on(
        NetworkConstants.receiveOrderStatusChangedSignalREvent,
        _handleOrderStatusChanged,
      );
      connection.on(
        NetworkConstants.receiveDriverArrivalStateChangedSignalREvent,
        _handleDriverArrivalStateChanged,
      );
      connection.on(
        NetworkConstants.receiveOrderSupportCaseChangedSignalREvent,
        _handleOrderSupportCaseChanged,
      );

      connection.onclose(({error}) {
        _connection = null;
        _logger.w('Notifications SignalR connection closed.', error: error);
        if (!_isManuallyStopped) {
          _scheduleReconnect();
        }
      });

      await connection.start();
      _connection = connection;
      _logger.i('Notifications SignalR connected.');
    } catch (error, stackTrace) {
      _logger.w(
        'Notifications SignalR connection failed.',
        error: error,
        stackTrace: stackTrace,
      );
      _connection = null;
      _scheduleReconnect();
    } finally {
      _isStarting = false;
    }
  }

  Future<void> _ensurePresenceConnected() async {
    if (_isStartingPresence) return;

    final currentConnection = _presenceConnection;
    if (currentConnection != null &&
        currentConnection.state != HubConnectionState.Disconnected) {
      return;
    }

    _isStartingPresence = true;
    try {
      final token = await _tokenService.getToken();
      if (token == null || token.trim().isEmpty) {
        return;
      }

      final connection = HubConnectionBuilder()
          .withUrl(
            _buildPresenceHubUrl(),
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token,
            ),
          )
          .withAutomaticReconnect()
          .build();

      connection.onclose(({error}) {
        _presenceConnection = null;
        _heartbeatTimer?.cancel();
        _heartbeatTimer = null;
        _logger.w('Customer presence SignalR connection closed.', error: error);
        if (!_isManuallyStopped) {
          _schedulePresenceReconnect();
        }
      });

      await connection.start();
      _presenceConnection = connection;
      _logger.i('Customer presence SignalR connected.');
    } catch (error, stackTrace) {
      _logger.w(
        'Customer presence SignalR connection failed.',
        error: error,
        stackTrace: stackTrace,
      );
      _presenceConnection = null;
      _schedulePresenceReconnect();
    } finally {
      _isStartingPresence = false;
    }
  }

  void _handleRealtimeNotification(List<Object?>? args) {
    final payload = _extractPayload(args);
    if (payload == null || _notificationsController.isClosed) return;

    final notification = AppNotificationDto.fromJson(payload).toEntity();
    if (_isDuplicateNotification(notification.id)) {
      _logger.i('Notifications SignalR duplicate skipped: ${notification.id}');
      return;
    }

    _logger.i(
      'Notifications SignalR event received. '
      'This realtime path only works while the app process is alive. '
      '${NotificationPayloadResolver.resolveDebugSummary(payload, title: notification.titleAr.isNotEmpty ? notification.titleAr : notification.titleEn, body: notification.bodyAr.isNotEmpty ? notification.bodyAr : notification.bodyEn)}',
    );
    _notificationsController.add(notification);
    _emitTrackingEventsFromPayload(
      payload,
      source: NetworkConstants.receiveNotificationSignalREvent,
    );
  }

  void _handleOrderStatusChanged(List<Object?>? args) {
    final payload = _extractPayload(args);
    if (payload == null || _orderStatusChangedController.isClosed) return;
    _logger.i(
      'Notifications SignalR order status event received from '
      '${NetworkConstants.receiveOrderStatusChangedSignalREvent}. '
      '${NotificationPayloadResolver.resolveDebugSummary(payload)}',
    );
    _orderStatusChangedController.add(
      OrderStatusChangedRealtimePayload.fromJson(payload),
    );
  }

  void _handleDriverArrivalStateChanged(List<Object?>? args) {
    final payload = _extractPayload(args);
    if (payload == null || _driverArrivalStateChangedController.isClosed) {
      return;
    }
    _logger.i(
      'Notifications SignalR driver arrival event received from '
      '${NetworkConstants.receiveDriverArrivalStateChangedSignalREvent}. '
      '${NotificationPayloadResolver.resolveDebugSummary(payload)}',
    );
    _driverArrivalStateChangedController.add(
      DriverArrivalStateChangedRealtimePayload.fromJson(payload),
    );
  }

  void _handleOrderSupportCaseChanged(List<Object?>? args) {
    final payload = _extractPayload(args);
    if (payload == null || _orderSupportCaseChangedController.isClosed) {
      return;
    }

    _logger.i(
      'Notifications SignalR support case event received from '
      '${NetworkConstants.receiveOrderSupportCaseChangedSignalREvent}. '
      '${NotificationPayloadResolver.resolveDebugSummary(payload)}',
    );
    _orderSupportCaseChangedController.add(
      OrderSupportCaseChangedRealtimePayload.fromJson(payload),
    );
  }

  void ingestExternalOrderRelatedPayload(
    Map<String, dynamic> payload, {
    String source = 'external',
  }) {
    _emitTrackingEventsFromPayload(payload, source: source);
  }

  bool _isDuplicateNotification(String notificationId) {
    if (_recentNotificationIdSet.contains(notificationId)) {
      return true;
    }

    _recentNotificationIds.add(notificationId);
    _recentNotificationIdSet.add(notificationId);

    if (_recentNotificationIds.length > _maxTrackedNotificationIds) {
      final removedId = _recentNotificationIds.removeAt(0);
      _recentNotificationIdSet.remove(removedId);
    }

    return false;
  }

  bool get _hasRealtimeListeners =>
      _notificationsController.hasListener ||
      _orderStatusChangedController.hasListener ||
      _driverArrivalStateChangedController.hasListener ||
      _orderSupportCaseChangedController.hasListener;

  void _scheduleReconnect() {
    if (_isReconnectScheduled || _isManuallyStopped || !_hasRealtimeListeners) {
      return;
    }

    _isReconnectScheduled = true;
    Future<void>.delayed(_reconnectDelay, () async {
      _isReconnectScheduled = false;
      if (_hasRealtimeListeners) {
        await _ensureConnected();
      }
    });
  }

  void _schedulePresenceReconnect() {
    if (_isPresenceReconnectScheduled || _isManuallyStopped) {
      return;
    }

    _isPresenceReconnectScheduled = true;
    Future<void>.delayed(_reconnectDelay, () async {
      _isPresenceReconnectScheduled = false;
      await _ensurePresenceConnected();
      if (_isAppInForeground) {
        await notifyAppForeground();
      }
    });
  }

  Future<void> handleAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await notifyAppForeground();
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      await notifyAppBackground();
    }
  }

  Future<void> notifyAppForeground() async {
    _isAppInForeground = true;
    await _ensurePresenceConnected();
    await _invokePresenceMethod(
      NetworkConstants.customerPresenceAppForegroundMethod,
    );
    _startHeartbeat();
  }

  Future<void> notifyAppBackground() async {
    _isAppInForeground = false;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    await _invokePresenceMethod(
      NetworkConstants.customerPresenceAppBackgroundMethod,
    );
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      unawaited(
        _invokePresenceMethod(NetworkConstants.customerPresenceHeartbeatMethod),
      );
    });
  }

  Future<void> _invokePresenceMethod(String methodName) async {
    if (_isManuallyStopped) return;

    await _ensurePresenceConnected();
    final connection = _presenceConnection;
    if (connection == null ||
        connection.state != HubConnectionState.Connected) {
      return;
    }

    try {
      await connection.invoke(methodName);
    } catch (error, stackTrace) {
      _logger.w(
        'Customer presence invoke failed for $methodName.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Map<String, dynamic>? _extractPayload(List<Object?>? args) {
    if (args == null || args.isEmpty) return null;

    final candidate = args.first;
    if (candidate is Map<String, dynamic>) {
      return candidate;
    }
    if (candidate is Map) {
      return candidate.map((key, value) => MapEntry(key.toString(), value));
    }
    if (candidate is String) {
      return _decodeJsonPayload(candidate);
    }
    if (candidate is List && candidate.isNotEmpty) {
      final nestedCandidate = candidate.first;
      if (nestedCandidate is Map<String, dynamic>) {
        return nestedCandidate;
      }
      if (nestedCandidate is Map) {
        return nestedCandidate.map(
          (key, value) => MapEntry(key.toString(), value),
        );
      }
      if (nestedCandidate is String) {
        return _decodeJsonPayload(nestedCandidate);
      }
    }

    return null;
  }

  Map<String, dynamic>? _decodeJsonPayload(String rawPayload) {
    final normalizedPayload = rawPayload.trim();
    if (normalizedPayload.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(normalizedPayload);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  void _emitTrackingEventsFromPayload(
    Map<String, dynamic> payload, {
    required String source,
  }) {
    final normalizedPayload = NotificationPayloadResolver.normalize(payload);
    final orderId = NotificationPayloadResolver.resolveOrderId(
      normalizedPayload,
    );
    if (orderId == null || orderId.isEmpty) {
      return;
    }

    final normalizedType =
        normalizedPayload['type']?.toString().trim().toLowerCase() ?? '';

    final arrivalState = _firstNonEmptyString([
      normalizedPayload['arrivalState'],
      normalizedPayload['driverArrivalState'],
    ]);
    if (arrivalState != null &&
        arrivalState.isNotEmpty &&
        _driverArrivalStateChangedController.hasListener &&
        (normalizedType.contains('driver_arrival') ||
            normalizedType.contains('arrival') ||
            normalizedType.isEmpty)) {
      final driverArrivalPayload = DriverArrivalStateChangedRealtimePayload
          .fromJson({
            'orderId': orderId,
            'orderNumber': normalizedPayload['orderNumber'],
            'arrivalState': arrivalState,
            'driverName': normalizedPayload['driverName'],
            'actorRole': normalizedPayload['actorRole'],
            'targetUrl': normalizedPayload['targetUrl'],
            'changedAtUtc': normalizedPayload['changedAtUtc'],
          });
      _logger.i(
        'Derived driver arrival tracking event from $source. '
        '${NotificationPayloadResolver.resolveDebugSummary(normalizedPayload)}',
      );
      _driverArrivalStateChangedController.add(driverArrivalPayload);
    }

    final newStatus = _firstNonEmptyString([
      normalizedPayload['newStatus'],
      normalizedPayload['status'],
    ]);
    if (newStatus != null &&
        newStatus.isNotEmpty &&
        _orderStatusChangedController.hasListener &&
        (normalizedType.contains('order_status_changed') ||
            normalizedType.contains('status_changed') ||
            normalizedType.isEmpty)) {
      final orderStatusPayload = OrderStatusChangedRealtimePayload.fromJson({
        'orderId': orderId,
        'orderNumber': normalizedPayload['orderNumber'],
        'vendorId': normalizedPayload['vendorId'],
        'oldStatus': normalizedPayload['oldStatus'],
        'newStatus': newStatus,
        'actorRole': normalizedPayload['actorRole'],
        'action': normalizedPayload['action'],
        'targetUrl': normalizedPayload['targetUrl'],
        'changedAtUtc': normalizedPayload['changedAtUtc'],
      });
      _logger.i(
        'Derived order status tracking event from $source. '
        '${NotificationPayloadResolver.resolveDebugSummary(normalizedPayload)}',
      );
      _orderStatusChangedController.add(orderStatusPayload);
    }
  }

  String? _firstNonEmptyString(Iterable<dynamic> values) {
    for (final value in values) {
      if (value == null) continue;
      final normalizedValue = value.toString().trim();
      if (normalizedValue.isNotEmpty) {
        return normalizedValue;
      }
    }

    return null;
  }

  String _buildHubUrl() {
    final baseUrlWithoutApi = NetworkConstants.baseUrl.replaceFirst(
      RegExp(r'/api/?$'),
      '',
    );
    return '$baseUrlWithoutApi${NetworkConstants.notificationsSignalRHubPath}';
  }

  String _buildPresenceHubUrl() {
    final baseUrlWithoutApi = NetworkConstants.baseUrl.replaceFirst(
      RegExp(r'/api/?$'),
      '',
    );
    return '$baseUrlWithoutApi${NetworkConstants.customerPresenceSignalRHubPath}';
  }
}
