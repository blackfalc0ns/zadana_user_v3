import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as ll;
import '../models/location_search_result.dart';

/// Location data source interface
abstract class LocationDataSource {
  /// Get address from coordinates using reverse geocoding
  Future<String> getAddressFromCoordinates(double latitude, double longitude);

  /// Get address from LatLng
  Future<String> getAddressFromLatLng(ll.LatLng coordinates);

  /// Search locations by query
  Future<List<LocationSearchResult>> searchLocations(String query);
}

/// Location data source implementation using Nominatim (OpenStreetMap) API
class LocationDataSourceImpl implements LocationDataSource {
  static const String _nominatimBaseUrl = 'https://nominatim.openstreetmap.org';

  @override
  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final uri = Uri.parse(
        '$_nominatimBaseUrl/reverse?format=json&lat=$latitude&lon=$longitude&accept-language=ar',
      );
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'ZadanaApp/1.0'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] ?? 'عنوان غير معروف';
      } else {
        throw LocationDataSourceException(
          'Failed to get address: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is LocationDataSourceException) rethrow;
      throw LocationDataSourceException('Failed to get address: $e');
    }
  }

  @override
  Future<String> getAddressFromLatLng(ll.LatLng coordinates) async {
    return await getAddressFromCoordinates(
      coordinates.latitude,
      coordinates.longitude,
    );
  }

  @override
  Future<List<LocationSearchResult>> searchLocations(String query) async {
    try {
      final uri = Uri.parse(
        '$_nominatimBaseUrl/search?format=json&q=$query&limit=10&accept-language=ar',
      );
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'ZadanaApp/1.0'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((result) {
          final lat = double.tryParse(result['lat']?.toString() ?? '') ?? 0.0;
          final lon = double.tryParse(result['lon']?.toString() ?? '') ?? 0.0;
          return LocationSearchResult(
            id: result['place_id']?.toString() ?? '',
            name: result['display_name']?.toString() ?? '',
            address: result['display_name']?.toString() ?? '',
            coordinates: ll.LatLng(lat, lon),
            placeId: result['place_id']?.toString(),
          );
        }).toList();
      } else {
        throw LocationDataSourceException(
          'Failed to search: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is LocationDataSourceException) rethrow;
      throw LocationDataSourceException('Failed to search locations: $e');
    }
  }
}

/// Location data source exception
class LocationDataSourceException implements Exception {
  final String message;

  const LocationDataSourceException(this.message);

  @override
  String toString() => 'LocationDataSourceException: $message';
}
