import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/services/app_navigator_service.dart';
import 'package:zadana_user_v3/core/services/push_notification_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';

/// Handles forced session expiry when the refresh token is no longer valid.
///
/// This service ensures the user is redirected to the login screen and all
/// local auth state is cleaned up when the backend rejects the refresh token.
@lazySingleton
class SessionExpiryService {
  SessionExpiryService(this._tokenService, this._appNavigatorService);

  final TokenService _tokenService;
  final AppNavigatorService _appNavigatorService;

  bool _isHandlingExpiry = false;

  /// Call this when a token refresh attempt fails irrecoverably.
  ///
  /// It clears tokens, logs out from push services, and navigates to login.
  /// Multiple concurrent calls are deduplicated — only the first one executes.
  Future<void> handleSessionExpired() async {
    if (_isHandlingExpiry) return;
    _isHandlingExpiry = true;

    try {
      await _tokenService.clearTokens();
      unawaited(PushNotificationService.logoutCustomer());

      final navigator = _appNavigatorService.navigator;
      if (navigator != null) {
        navigator.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      }
    } finally {
      _isHandlingExpiry = false;
    }
  }
}
