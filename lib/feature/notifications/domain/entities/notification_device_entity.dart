class NotificationDeviceEntity {
  const NotificationDeviceEntity({
    required this.id,
    required this.deviceToken,
    required this.platform,
    required this.deviceId,
    required this.deviceName,
    required this.appVersion,
    required this.locale,
    required this.notificationsEnabled,
    required this.isActive,
    required this.lastRegisteredAtUtc,
    required this.lastSeenAtUtc,
  });

  final String id;
  final String? deviceToken;
  final String? platform;
  final String? deviceId;
  final String? deviceName;
  final String? appVersion;
  final String? locale;
  final bool notificationsEnabled;
  final bool isActive;
  final DateTime? lastRegisteredAtUtc;
  final DateTime? lastSeenAtUtc;
}
