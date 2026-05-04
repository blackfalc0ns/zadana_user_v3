import 'dart:async';
import 'dart:developer' as developer;

import 'package:zadana_user_v3/core/services/notification_device_service.dart';
import 'package:zadana_user_v3/core/services/push_notification_service.dart';
import 'package:zadana_user_v3/feature/cart/domain/repo/cart_repository.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';

void runPostAuthSideEffects({
  required String logName,
  required CartRepository cartRepository,
  required FavoritesRepository favoritesRepository,
  required NotificationsSignalRService notificationsSignalRService,
  required NotificationDeviceService notificationDeviceService,
  String? customerId,
}) {
  unawaited(
    _runPostAuthSideEffects(
      logName: logName,
      cartRepository: cartRepository,
      favoritesRepository: favoritesRepository,
      notificationsSignalRService: notificationsSignalRService,
      notificationDeviceService: notificationDeviceService,
      customerId: customerId,
    ),
  );
}

Future<void> _runPostAuthSideEffects({
  required String logName,
  required CartRepository cartRepository,
  required FavoritesRepository favoritesRepository,
  required NotificationsSignalRService notificationsSignalRService,
  required NotificationDeviceService notificationDeviceService,
  String? customerId,
}) async {
  final normalizedCustomerId = customerId?.trim() ?? '';

  await Future.wait<void>([
    _runTaskSafely(
      logName,
      'notifications realtime connection',
      notificationsSignalRService.activateAuthenticatedConnectionIfPossible,
    ),
    if (normalizedCustomerId.isNotEmpty)
      _runTaskSafely(
        logName,
        'OneSignal login',
        () => PushNotificationService.loginCustomer(normalizedCustomerId),
      ),
    _runTaskSafely(
      logName,
      'guest cart sync',
      cartRepository.syncGuestCartIfAuthenticated,
    ),
    _runTaskSafely(
      logName,
      'guest favorites sync',
      favoritesRepository.syncGuestFavoritesIfAuthenticated,
    ),
    _runTaskSafely(
      logName,
      'notification device sync',
      () => notificationDeviceService.syncCurrentDeviceIfAuthenticated(
        force: true,
      ),
    ),
  ]);
}

Future<void> _runTaskSafely(
  String logName,
  String taskName,
  Future<Object?> Function() task,
) async {
  try {
    await task();
  } catch (error, stackTrace) {
    developer.log(
      'Post-auth task failed: $taskName',
      name: logName,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
