import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/services/push_notification_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';

/// Clears local session state after the server has closed an account.
/// This intentionally does not call the normal logout endpoint: the account's
/// tokens have been revoked and must never enter a refresh-token flow.
class AccountCloseHelper {
  const AccountCloseHelper._();

  static Future<void> complete(BuildContext context) async {
    await getIt<NotificationsSignalRService>().disconnect();
    await PushNotificationService.logoutCustomer();
    await getIt<TokenService>().clearTokens();

    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
      arguments: true,
    );
  }
}
