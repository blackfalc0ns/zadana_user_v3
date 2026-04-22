import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/track_order/data/models/order_status_changed_realtime_payload.dart';

@lazySingleton
class TrackOrderSignalRService {
  TrackOrderSignalRService(this._tokenService);

  final TokenService _tokenService;
  final Logger _logger = Logger();
  static const Duration _reconnectDelay = Duration(seconds: 5);
  final StreamController<OrderStatusChangedRealtimePayload>
  _orderStatusChangedController =
      StreamController<OrderStatusChangedRealtimePayload>.broadcast();

  HubConnection? _connection;
  bool _isStarting = false;
  bool _isReconnectScheduled = false;

  Stream<OrderStatusChangedRealtimePayload> watchOrderStatusChangedEvents() {
    unawaited(_ensureConnected());
    return _orderStatusChangedController.stream;
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
          'Track order SignalR skipped because no access token is available yet.',
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
        NetworkConstants.receiveOrderStatusChangedSignalREvent,
        _handleOrderStatusChanged,
      );

      connection.onclose(({error}) {
        _connection = null;
        _logger.w('Track order SignalR connection closed.', error: error);
        _scheduleReconnect();
      });

      await connection.start();
      _connection = connection;
      _logger.i('Track order SignalR connected.');
    } catch (error, stackTrace) {
      _logger.w(
        'Track order SignalR connection failed.',
        error: error,
        stackTrace: stackTrace,
      );
      _connection = null;
      _scheduleReconnect();
    } finally {
      _isStarting = false;
    }
  }

  void _handleOrderStatusChanged(List<Object?>? args) {
    final payload = _extractPayload(args);
    if (payload == null || _orderStatusChangedController.isClosed) return;
    _orderStatusChangedController.add(
      OrderStatusChangedRealtimePayload.fromJson(payload),
    );
  }

  void _scheduleReconnect() {
    if (_isReconnectScheduled || !_orderStatusChangedController.hasListener) {
      return;
    }

    _isReconnectScheduled = true;
    Future<void>.delayed(_reconnectDelay, () async {
      _isReconnectScheduled = false;
      if (_orderStatusChangedController.hasListener) {
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
    return '$baseUrlWithoutApi${NetworkConstants.ordersSignalRHubPath}';
  }
}
