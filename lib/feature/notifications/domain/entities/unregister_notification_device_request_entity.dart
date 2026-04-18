class UnregisterNotificationDeviceRequestEntity {
  const UnregisterNotificationDeviceRequestEntity({
    this.deviceId,
    this.deviceToken,
  });

  final String? deviceId;
  final String? deviceToken;
}
