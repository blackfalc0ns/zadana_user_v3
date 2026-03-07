import 'package:either_dart/either.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../datasources/location_datasource.dart';
import '../models/location_model.dart';
import '../models/location_search_result.dart';

/// Location repository interface
abstract class LocationRepository {
  /// Get address from coordinates
  Future<Either<LocationRepositoryException, String>> getAddressFromCoordinates(
    double latitude,
    double longitude,
  );
  
  /// Get address from LatLng
  Future<Either<LocationRepositoryException, String>> getAddressFromLatLng(
    ll.LatLng coordinates,
  );
  
  /// Create location model from coordinates
  Future<Either<LocationRepositoryException, LocationModel>> createLocationModel({
    required double latitude,
    required double longitude,
  });
  
  /// Search locations by query
  Future<Either<LocationRepositoryException, List<LocationSearchResult>>> searchLocations(String query);
}

/// Location repository implementation
class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl({required this.dataSource});

  @override
  Future<Either<LocationRepositoryException, String>> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final address = await dataSource.getAddressFromCoordinates(latitude, longitude);
      return Right(address);
    } catch (e) {
      return Left(LocationRepositoryException('Failed to get address: $e'));
    }
  }

  @override
  Future<Either<LocationRepositoryException, String>> getAddressFromLatLng(
    ll.LatLng coordinates,
  ) async {
    try {
      final address = await dataSource.getAddressFromLatLng(coordinates);
      return Right(address);
    } catch (e) {
      return Left(LocationRepositoryException('Failed to get address: $e'));
    }
  }

  @override
  Future<Either<LocationRepositoryException, LocationModel>> createLocationModel({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final addressResult = await getAddressFromCoordinates(latitude, longitude);
      
      return addressResult.fold(
        (failure) => Left(failure),
        (address) => Right(LocationModel.fromCoordinates(
          latitude: latitude,
          longitude: longitude,
          address: address,
        )),
      );
    } catch (e) {
      return Left(LocationRepositoryException('Failed to create location model: $e'));
    }
  }

  @override
  Future<Either<LocationRepositoryException, List<LocationSearchResult>>> searchLocations(String query) async {
    try {
      final results = await dataSource.searchLocations(query);
      return Right(results);
    } catch (e) {
      return Left(LocationRepositoryException('Failed to search locations: $e'));
    }
  }
}

/// Location repository exception
class LocationRepositoryException implements Exception {
  final String message;
  
  const LocationRepositoryException(this.message);
  
  @override
  String toString() => 'LocationRepositoryException: $message';
}
