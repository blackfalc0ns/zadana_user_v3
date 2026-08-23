import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class NotificationDeduplicator {
  static const Duration deduplicationWindow = Duration(seconds: 15);
  static const Duration cleanupWindow = Duration(seconds: 60);

  final Map<String, DateTime> _recordedKeys = <String, DateTime>{};
  final Logger _logger = Logger();

  /// Determines whether a notification should be displayed based on recent history.
  /// If it was displayed recently, returns `false` (duplicate).
  /// Otherwise, records the keys and returns `true`.
  bool shouldDisplay({
    String? notificationId,
    String? orderId,
    String? status,
    String? type,
    String? title,
    String? body,
    String? source,
  }) {
    _cleanupExpiredEntries();

    final keys = _generateKeys(
      notificationId: notificationId,
      orderId: orderId,
      status: status,
      type: type,
      title: title,
      body: body,
    );

    if (keys.isEmpty) {
      return true;
    }

    final now = DateTime.now();
    for (final key in keys) {
      final lastRecorded = _recordedKeys[key];
      if (lastRecorded != null && now.difference(lastRecorded) < deduplicationWindow) {
        _logger.i(
          'Notification deduplicated (skipped). Source: $source, Matched key: $key, '
          'Elapsed: ${now.difference(lastRecorded).inMilliseconds}ms',
        );
        return false;
      }
    }

    for (final key in keys) {
      _recordedKeys[key] = now;
    }

    return true;
  }

  /// Manually records a notification as displayed.
  void recordDisplayed({
    String? notificationId,
    String? orderId,
    String? status,
    String? type,
    String? title,
    String? body,
  }) {
    _cleanupExpiredEntries();
    final keys = _generateKeys(
      notificationId: notificationId,
      orderId: orderId,
      status: status,
      type: type,
      title: title,
      body: body,
    );

    final now = DateTime.now();
    for (final key in keys) {
      _recordedKeys[key] = now;
    }
  }

  /// Computes a stable deterministic integer notification ID for system notifications.
  int resolveSystemNotificationId({
    String? notificationId,
    String? orderId,
    String? status,
    String? type,
    String? title,
    String? body,
  }) {
    final normalizedNotificationId = notificationId?.trim();
    if (normalizedNotificationId != null &&
        normalizedNotificationId.isNotEmpty &&
        !normalizedNotificationId.startsWith('synthetic-')) {
      return normalizedNotificationId.hashCode;
    }

    final normalizedOrderId = orderId?.trim();
    if (normalizedOrderId != null && normalizedOrderId.isNotEmpty) {
      return 'order-$normalizedOrderId'.hashCode;
    }

    final contentKey = '${title?.trim() ?? ''}|${body?.trim() ?? ''}';
    if (contentKey != '|') {
      return contentKey.hashCode;
    }

    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  List<String> _generateKeys({
    String? notificationId,
    String? orderId,
    String? status,
    String? type,
    String? title,
    String? body,
  }) {
    final keys = <String>[];

    final normalizedId = notificationId?.trim();
    if (normalizedId != null &&
        normalizedId.isNotEmpty &&
        !normalizedId.startsWith('synthetic-')) {
      keys.add('id:$normalizedId');
    }

    final normalizedOrderId = orderId?.trim();
    final normalizedStatus = status?.trim().toLowerCase();
    final normalizedType = type?.trim().toLowerCase();

    if (normalizedOrderId != null && normalizedOrderId.isNotEmpty) {
      if (normalizedStatus != null && normalizedStatus.isNotEmpty) {
        keys.add('order:$normalizedOrderId:status:$normalizedStatus');
      }
      if (normalizedType != null && normalizedType.isNotEmpty) {
        keys.add('order:$normalizedOrderId:type:$normalizedType');
      }
      keys.add('order:$normalizedOrderId');
    }

    final normalizedTitle = title?.trim().toLowerCase() ?? '';
    final normalizedBody = body?.trim().toLowerCase() ?? '';
    if (normalizedTitle.isNotEmpty || normalizedBody.isNotEmpty) {
      keys.add('content:$normalizedTitle:$normalizedBody');
    }

    return keys;
  }

  void _cleanupExpiredEntries() {
    final now = DateTime.now();
    _recordedKeys.removeWhere((_, timestamp) => now.difference(timestamp) > cleanupWindow);
  }
}
