import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';

class SavedLocationService {
  SavedLocationService._();

  static const String _locationKey = 'saved_location';

  static SharedPreferences get _prefs => GetIt.instance<SharedPreferences>();

  static bool get hasSavedLocation =>
      (_prefs.getString(_locationKey) ?? '').isNotEmpty;

  static Future<void> saveLocation(LocationEntity location) async {
    await _prefs.setString(
      _locationKey,
      jsonEncode({
        'addressLine': location.addressLine,
        'city': location.city,
        'area': location.area,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'buildingNo': location.buildingNo,
        'floorNo': location.floorNo,
        'apartmentNo': location.apartmentNo,
        'label': location.label,
      }),
    );
  }

  static LocationEntity? getSavedLocation() {
    final raw = _prefs.getString(_locationKey);
    if (raw == null || raw.isEmpty) return null;

    final json = jsonDecode(raw) as Map<String, dynamic>;
    return LocationEntity(
      addressLine: json['addressLine'] as String? ?? '',
      city: json['city'] as String? ?? '',
      area: json['area'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      buildingNo: json['buildingNo'] as String? ?? '',
      floorNo: json['floorNo'] as String? ?? '',
      apartmentNo: json['apartmentNo'] as String? ?? '',
      label: json['label'] as String? ?? '',
    );
  }
}
