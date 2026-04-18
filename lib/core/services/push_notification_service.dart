import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushNotificationService {
  static const String _appId = "e557da4e-947b-468b-ab5b-37c552c35dca";

  static Future<void> init() async {
    try {
      // Remove this method to stop OneSignal Debugging
      // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

      OneSignal.initialize(_appId);

      OneSignal.Notifications.requestPermission(true);

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

      Logger().i("OneSignal initialized with ID: $_appId");
    } catch (e) {
      Logger().e("Error initializing OneSignal: $e");
    }
  }
}
