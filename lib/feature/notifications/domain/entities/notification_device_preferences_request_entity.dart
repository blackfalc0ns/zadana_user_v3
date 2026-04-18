class NotificationDevicePreferencesRequestEntity {
  const NotificationDevicePreferencesRequestEntity({
    this.deviceId,
    this.deviceToken,
    required this.notificationsEnabled,
  });

  final String? deviceId;
  final String? deviceToken;
  final bool notificationsEnabled;
}
