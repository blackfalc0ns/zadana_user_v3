import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/services/notification_device_service.dart';

class PushNotificationService {
  static const String _appId = "e557da4e-947b-468b-ab5b-37c552c35dca";
  static const String androidHeadsUpChannelId = "zadana_heads_up_notifications";
  static final Logger _logger = Logger();
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) {
      _logger.w('PushNotificationService.init() was called more than once.');
      return;
    }

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

      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        final title = event.notification.title?.trim();
        final body = event.notification.body?.trim();
        final hasVisibleContent =
            (title?.isNotEmpty ?? false) || (body?.isNotEmpty ?? false);

        if (!hasVisibleContent) {
          _logger.w(
            'Foreground notification arrived without visible title/body. '
            'This payload will not produce a standard popup notification.',
          );
          return;
        }

        // Keep foreground notifications visible instead of being handled silently.
        event.preventDefault();
        event.notification.display();
        _logger.i(
          'Foreground notification displayed. '
          'title: ${title ?? '(empty)'}, body exists: ${body?.isNotEmpty ?? false}',
        );
      });

      OneSignal.Notifications.addClickListener((event) {
        _logger.i(
          'Notification clicked: ${event.notification.additionalData}',
        );
      });

      await OneSignal.User.pushSubscription.optIn();
      await _cachePushTokenIfAvailable(OneSignal.User.pushSubscription.token);

      final permissionGranted = await OneSignal.Notifications.requestPermission(
        true,
      );
      _logger.i('Notification permission granted: $permissionGranted');
      await _cachePushTokenIfAvailable(OneSignal.User.pushSubscription.token);

      _logger.i("OneSignal initialized with ID: $_appId");
      _isInitialized = true;
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
