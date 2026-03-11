
// import '../models/location_search_result.dart';

// /// Location data source interface
// abstract class LocationDataSource {
//   /// Get address from coordinates using reverse geocoding
//   Future<String> getAddressFromCoordinates(
//     double latitude,
//     double longitude,
//   );
//   /// Search locations by query
//   Future<List<LocationSearchResult>> searchLocations(String query);
// }

// /// Location data source implementation using Retrofit
// /// Data layer - API implementation
// // @Injectable(as: LocationDataSource)
// // class LocationDataSourceImpl implements LocationDataSource {
// //   final ApiServices _apiServices;

// //   const LocationDataSourceImpl(this._apiServices);

// //   @override
// //   Future<String> getAddressFromCoordinates(
// //     double latitude,
// //     double longitude,
// //   ) async {
// //     final response = await _apiServices.getAddress(latitude, longitude);
// //     return response.address;
// //   }

// //   @override
// //   Future<List<LocationSearchResult>> searchLocations(String query) async {
// //     final results = await _apiServices.searchLocations(query);
// //     return results.map((dto) => dto.toModel()).toList();
// //   }
// // }


import 'package:zadana_user_v3/feature/location/data/models/location_search_dto.dart';
import 'package:zadana_user_v3/feature/location/data/models/current_location_dto.dart';
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