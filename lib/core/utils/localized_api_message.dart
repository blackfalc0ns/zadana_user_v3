import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/services/language_service.dart';

String resolveLocalizedApiMessage(
  Map<String, dynamic> json, {
  String fallbackKey = 'message',
}) {
  final isArabic = _currentLanguageCode().startsWith('ar');
  final primaryKeys = isArabic
      ? const ['message_ar', 'messageAr']
      : const ['message_en', 'messageEn'];
  final secondaryKeys = isArabic
      ? const ['message_en', 'messageEn']
      : const ['message_ar', 'messageAr'];

  return _readFirstAvailable(json, primaryKeys) ??
      _readFirstAvailable(json, secondaryKeys) ??
      _readString(json[fallbackKey]) ??
      '';
}

String resolveLocalizedApiMessageFromQuery(Map<String, String?> query) {
  final isArabic = _currentLanguageCode().startsWith('ar');
  final primaryKeys = isArabic
      ? const ['data.message_ar', 'data.messageAr']
      : const ['data.message_en', 'data.messageEn'];
  final secondaryKeys = isArabic
      ? const ['data.message_en', 'data.messageEn']
      : const ['data.message_ar', 'data.messageAr'];

  return _readFirstAvailableFromQuery(query, primaryKeys) ??
      _readFirstAvailableFromQuery(query, secondaryKeys) ??
      query['data.message']?.trim() ??
      '';
}

String _currentLanguageCode() {
  if (!getIt.isRegistered<LanguageService>()) {
    return 'ar';
  }

  return getIt<LanguageService>().getLanguageCode().toLowerCase();
}

String? _readString(dynamic value) {
  final normalized = value?.toString().trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }

  return normalized;
}

String? _readFirstAvailable(
  Map<String, dynamic> json,
  List<String> keys,
) {
  for (final key in keys) {
    final value = _readString(json[key]);
    if (value != null) {
      return value;
    }
  }

  return null;
}

String? _readFirstAvailableFromQuery(
  Map<String, String?> query,
  List<String> keys,
) {
  for (final key in keys) {
    final value = query[key]?.trim();
    if (value != null && value.isNotEmpty) {
      return value;
    }
  }

  return null;
}
