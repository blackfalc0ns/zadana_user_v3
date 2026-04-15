import 'package:zadana_user_v3/feature/location/data/models/current_location_dto.dart';
import 'package:zadana_user_v3/feature/location/data/models/location_search_dto.dart';
import 'package:zadana_user_v3/feature/location/data/models/reverse_location_dto.dart';

abstract class LocationDataSource {
  /// Search locations using OpenStreetMap
  Future<List<LocationSearchDto>> searchLocations(String query);

  /// Reverse geocoding (lat/lon → address)
  Future<ReverseLocationDto> getAddressFromCoordinates(
    double latitude,
    double longitude,
  );

  /// Get current device location
  Future<CurrentLocationDto> getCurrentCoordinates();
}
