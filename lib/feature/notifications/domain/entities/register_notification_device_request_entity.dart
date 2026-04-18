class RegisterNotificationDeviceRequestEntity {
  const RegisterNotificationDeviceRequestEntity({
    required this.deviceToken,
    required this.platform,
    this.deviceId,
    this.deviceName,
    this.appVersion,
    this.locale,
    this.notificationsEnabled,
  });

  final String deviceToken;
  final String platform;
  final String? deviceId;
  final String? deviceName;
  final String? appVersion;
  final String? locale;
  final bool? notificationsEnabled;
}
