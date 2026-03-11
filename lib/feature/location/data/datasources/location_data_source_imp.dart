// import 'package:injectable/injectable.dart';
// import 'package:zadana_user_v3/core/network/api_services.dart';
// import 'package:zadana_user_v3/feature/location/data/datasources/location_datasource.dart';
// import 'package:zadana_user_v3/feature/location/data/models/location_search_result.dart';

// @Injectable(as: LocationDataSource)
// class LocationDataSourceImpl implements LocationDataSource {
//   final ApiServices _apiServices;

//   const LocationDataSourceImpl(this._apiServices);

//   @override
//   Future<String> getAddressFromCoordinates(
//     double latitude,
//     double longitude,
//   ) async {
//     final response = await _apiServices.getAddress(latitude, longitude);
//     return response.address;
//   }

//   @override
//   Future<List<LocationSearchResult>> searchLocations(String query) async {
//     final results = await _apiServices.searchLocations(query);
//     return results.map((dto) => dto.toModel()).toList();
//   }
// }

import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/helpers/permision_service.dart';
import 'package:zadana_user_v3/core/network/osm_api_services.dart';
import 'package:zadana_user_v3/feature/location/data/datasources/location_datasource.dart';
import 'package:zadana_user_v3/feature/location/data/models/current_location_dto.dart';
import 'package:zadana_user_v3/feature/location/data/models/location_search_dto.dart';
import 'package:zadana_user_v3/feature/location/data/models/reverse_location_dto.dart';

@Injectable(as: LocationDataSource)
class LocationDataSourceImpl implements LocationDataSource {
  final OsmApiServices api;
  final LocationPermissionService permissionService;

  LocationDataSourceImpl(this.api, this.permissionService);

  /// 🔎 Search locations by name
  @override
  Future<List<LocationSearchDto>> searchLocations(String query) {
    return api.searchLocations(query, 'json', 'ar', 1, 10);
  }

  /// 📍 Reverse geocoding
  @override
  Future<ReverseLocationDto> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) {
    return api.reverseGeocode(latitude, longitude, 'json', 'ar');
  }

  /// 📱 Get device location
  @override
  Future<CurrentLocationDto> getCurrentCoordinates() async {
    /// check permission first
    await permissionService.checkAndRequestPermission();

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return CurrentLocationDto(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
