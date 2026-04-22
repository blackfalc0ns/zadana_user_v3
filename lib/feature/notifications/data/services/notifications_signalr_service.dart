import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/notifications/data/models/app_notification_dto.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/app_notification_entity.dart';

@lazySingleton
class NotificationsSignalRService {
  NotificationsSignalRService(this._tokenService);

  final TokenService _tokenService;
  final Logger _logger = Logger();
  static const Duration _reconnectDelay = Duration(seconds: 5);
  static const int _maxTrackedNotificationIds = 200;
  final StreamController<AppNotificationEntity> _notificationsController =
      StreamController<AppNotificationEntity>.broadcast();
  final List<String> _recentNotificationIds = <String>[];
  final Set<String> _recentNotificationIdSet = <String>{};

  HubConnection? _connection;
  bool _isStarting = false;
  bool _isReconnectScheduled = false;

  Stream<AppNotificationEntity> watchNotifications() {
    unawaited(_ensureConnected());
    return _notificationsController.stream;
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
        _logger.w(
          'Notifications SignalR skipped because no access token is available yet.',
        );
        _scheduleReconnect();
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

      connection.onclose(({error}) {
        _connection = null;
        _logger.w('Notifications SignalR connection closed.', error: error);
        _scheduleReconnect();
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

  void _handleRealtimeNotification(List<Object?>? args) {
    final payload = _extractPayload(args);
    if (payload == null || _notificationsController.isClosed) return;

    final notification = AppNotificationDto.fromJson(payload).toEntity();
    if (_isDuplicateNotification(notification.id)) {
      _logger.i('Notifications SignalR duplicate skipped: ${notification.id}');
      return;
    }

    _logger.i(
      'Notifications SignalR event received: '
      '${payload['type'] ?? payload['id'] ?? 'unknown'}',
    );
    _notificationsController.add(notification);
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

  void _scheduleReconnect() {
    if (_isReconnectScheduled || !_notificationsController.hasListener) {
      return;
    }

    _isReconnectScheduled = true;
    Future<void>.delayed(_reconnectDelay, () async {
      _isReconnectScheduled = false;
      if (_notificationsController.hasListener) {
        await _ensureConnected();
      }
    });
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

    return null;
  }

  String _buildHubUrl() {
    final baseUrlWithoutApi = NetworkConstants.baseUrl.replaceFirst(
      RegExp(r'/api/?$'),
      '',
    );
    return '$baseUrlWithoutApi${NetworkConstants.notificationsSignalRHubPath}';
  }
}
