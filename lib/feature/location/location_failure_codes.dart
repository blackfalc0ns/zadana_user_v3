class LocationFailureCodes {
  LocationFailureCodes._();

  static const String searchTemporarilyUnavailable =
      'location_search_temporarily_unavailable';
  static const String rateLimitRetry = 'location_rate_limit_retry';
  static const String serviceDisabled = 'location_service_disabled';
  static const String permissionDenied = 'location_permission_denied';
  static const String permissionDeniedForever =
      'location_permission_denied_forever';
}
