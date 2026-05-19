import 'dart:async';
import 'dart:developer' as developer;

import 'package:zadana_user_v3/core/services/checkout_flow_service.dart';
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
  // Only store the cart sync future for the checkout flow — other tasks
  // (SignalR, OneSignal, etc.) should not block the payment screen.
  final cartSyncFuture = _runTaskSafely(
    logName,
    'guest cart sync',
    cartRepository.syncGuestCartIfAuthenticated,
  );
  CheckoutFlowService().setCartSyncFuture(cartSyncFuture);

  final future = _runPostAuthSideEffects(
    logName: logName,
    cartSyncFuture: cartSyncFuture,
    favoritesRepository: favoritesRepository,
    notificationsSignalRService: notificationsSignalRService,
    notificationDeviceService: notificationDeviceService,
    customerId: customerId,
  );
  unawaited(future);
}

Future<void> _runPostAuthSideEffects({
  required String logName,
  required Future<void> cartSyncFuture,
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
    cartSyncFuture,
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
