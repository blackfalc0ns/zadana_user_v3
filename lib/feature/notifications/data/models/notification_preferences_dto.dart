class NotificationPreferencesDto {
  const NotificationPreferencesDto({
    required this.pushEnabled,
    required this.sound,
    required this.mobileDeviceCount,
  });

  factory NotificationPreferencesDto.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesDto(
      pushEnabled: json['push_enabled'] as bool? ?? true,
      sound: json['sound']?.toString() ?? 'default',
      mobileDeviceCount: json['mobile_device_count'] as int? ?? 0,
    );
  }

  final bool pushEnabled;
  final String sound;
  final int mobileDeviceCount;

  Map<String, dynamic> toMap() {
    return {
      'push_enabled': pushEnabled,
      'sound': sound,
      'mobile_device_count': mobileDeviceCount,
    };
  }
}
