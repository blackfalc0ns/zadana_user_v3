import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart'
    as core_constants;
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/device_id_service.dart';
import 'package:zadana_user_v3/core/services/language_service.dart';
import 'package:zadana_user_v3/core/services/push_token_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/core/utils/constants.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notification_device_preferences_request_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/register_notification_device_request_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/unregister_notification_device_request_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/usecase/register_notification_device_usecase.dart';
import 'package:zadana_user_v3/feature/notifications/domain/usecase/unregister_notification_device_usecase.dart';
import 'package:zadana_user_v3/feature/notifications/domain/usecase/update_notification_device_preferences_usecase.dart';

@lazySingleton
class NotificationDeviceService {
  NotificationDeviceService(
    this._sharedPreferences,
    this._tokenService,
    this._pushTokenService,
    this._deviceIdService,
    this._languageService,
    this._registerNotificationDeviceUseCase,
    this._updateNotificationDevicePreferencesUseCase,
    this._unregisterNotificationDeviceUseCase,
  );

  final SharedPreferences _sharedPreferences;
  final TokenService _tokenService;
  final PushTokenService _pushTokenService;
  final DeviceIdService _deviceIdService;
  final LanguageService _languageService;
  final RegisterNotificationDeviceUseCase _registerNotificationDeviceUseCase;
  final UpdateNotificationDevicePreferencesUseCase
  _updateNotificationDevicePreferencesUseCase;
  final UnregisterNotificationDeviceUseCase
  _unregisterNotificationDeviceUseCase;

  Future<bool> isNotificationsEnabled() async {
    return _sharedPreferences.getBool(AppConstants.notificationsEnabledKey) ??
        true;
  }

  Future<void> saveNotificationsEnabledLocally(bool enabled) async {
    await _sharedPreferences.setBool(
      AppConstants.notificationsEnabledKey,
      enabled,
    );
  }

  Future<ApiResult<void>> cachePushToken(String token) async {
    await _pushTokenService.saveToken(token);
    return syncCurrentDeviceIfAuthenticated();
  }

  Future<ApiResult<void>> syncCurrentDeviceIfAuthenticated() async {
    final accessToken = await _tokenService.getToken();
    final deviceToken = _pushTokenService.getToken();
    if (accessToken == null ||
        accessToken.isEmpty ||
        deviceToken == null ||
        deviceToken.isEmpty) {
      return safeLocalCall(() async {});
    }

    final deviceId = await _deviceIdService.getOrCreateDeviceId();
    final notificationsEnabled = await isNotificationsEnabled();

    return _registerNotificationDeviceUseCase(
      RegisterNotificationDeviceRequestEntity(
        deviceToken: deviceToken,
        platform: _resolvePlatform(),
        deviceId: deviceId,
        deviceName: _resolveDeviceName(),
        appVersion: core_constants.AppConstants.appVersion,
        locale: _languageService.getLanguageCode(),
        notificationsEnabled: notificationsEnabled,
      ),
    );
  }

  Future<ApiResult<void>> setNotificationsEnabled(bool enabled) async {
    await saveNotificationsEnabledLocally(enabled);

    final accessToken = await _tokenService.getToken();
    if (accessToken == null || accessToken.isEmpty) {
      return safeLocalCall(() async {});
    }

    final deviceId = await _deviceIdService.getOrCreateDeviceId();
    final deviceToken = _pushTokenService.getToken();

    return _updateNotificationDevicePreferencesUseCase(
      NotificationDevicePreferencesRequestEntity(
        deviceId: deviceId,
        deviceToken: deviceToken,
        notificationsEnabled: enabled,
      ),
    );
  }

  Future<ApiResult<void>> unregisterCurrentDevice() async {
    final accessToken = await _tokenService.getToken();
    if (accessToken == null || accessToken.isEmpty) {
      return safeLocalCall(() async {});
    }

    final deviceId = await _deviceIdService.getOrCreateDeviceId();
    final deviceToken = _pushTokenService.getToken();

    return _unregisterNotificationDeviceUseCase(
      UnregisterNotificationDeviceRequestEntity(
        deviceId: deviceId,
        deviceToken: deviceToken,
      ),
    );
  }

  String _resolvePlatform() {
    if (kIsWeb) return 'fcm';
    if (Platform.isIOS || Platform.isMacOS) {
      return 'apns';
    }
    return 'fcm';
  }

  String _resolveDeviceName() {
    if (kIsWeb) return 'Web';
    if (Platform.isIOS) return 'iPhone';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Device';
  }
}
