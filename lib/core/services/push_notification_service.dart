import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/services/notification_device_service.dart';

class PushNotificationService {
  static const String _appId = "e557da4e-947b-468b-ab5b-37c552c35dca";
  static final Logger _logger = Logger();

  static Future<void> init() async {
    try {
      // Remove this method to stop OneSignal Debugging
      // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

      await OneSignal.initialize(_appId);

      OneSignal.Notifications.addPermissionObserver((permission) {
        _logger.i('Notification permission changed: $permission');
      });

      OneSignal.User.pushSubscription.addObserver((state) async {
        final token = state.current.token;
        final subscriptionId = state.current.id;
        _logger.i(
          'Push subscription changed. id: $subscriptionId, token exists: ${token != null && token.isNotEmpty}',
        );
        await _cachePushTokenIfAvailable(token);
      });

      // This ensures notifications are displayed as standard alerts even when the app is open
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        event
            .preventDefault(); // Prevent default behavior (which might be silent)
        event.notification.display(); // Explicitly show the notification
        Logger().i(
          "Foreground notification received: ${event.notification.title}",
        );
      });

      OneSignal.Notifications.addClickListener((event) {
        Logger().i(
          "Notification clicked: ${event.notification.additionalData}",
        );
      });

      await _cachePushTokenIfAvailable(OneSignal.User.pushSubscription.token);

      final permissionGranted = await OneSignal.Notifications.requestPermission(
        true,
      );
      _logger.i('Notification permission granted: $permissionGranted');
      await _cachePushTokenIfAvailable(OneSignal.User.pushSubscription.token);

      _logger.i("OneSignal initialized with ID: $_appId");
    } catch (e) {
      _logger.e("Error initializing OneSignal: $e");
    }
  }

  static Future<void> _cachePushTokenIfAvailable(String? token) async {
    if (token == null || token.trim().isEmpty) {
      _logger.w('Push token is still unavailable.');
      return;
    }

    await getIt<NotificationDeviceService>().cachePushToken(token);
    _logger.i('Push token cached and synced with backend.');
  }
}
