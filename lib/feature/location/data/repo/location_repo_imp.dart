import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/location/data/datasources/location_data_source.dart';
import 'package:zadana_user_v3/feature/location/data/mapper/location_mapper.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_search_entity.dart';
import 'package:zadana_user_v3/feature/location/domain/repo/location_repo.dart';

@Injectable(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl(this.dataSource);
  final LocationDataSource dataSource;

  @override
  Future<ApiResult<List<LocationSearchResultEntity>>> searchLocations(
    String query,
  ) async {
    return await safeApiCall<List<LocationSearchResultEntity>>(() async {
      final response = await dataSource.searchLocations(query);

      return LocationMapper.searchListToEntity(response);
    });
  }

  @override
  Future<ApiResult<LocationEntity>> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    return await safeApiCall<LocationEntity>(() async {
      final response = await dataSource.getAddressFromCoordinates(
        latitude,
        longitude,
      );

      return LocationMapper.reverseDtoToEntity(
        response,
        fallbackLatitude: latitude,
        fallbackLongitude: longitude,
      );
    });
  }

  @override
  Future<ApiResult<LocationEntity>> getCurrentLocationWithAddress() async {
    return await safeApiCall<LocationEntity>(() async {
      final currentCoordinates = await dataSource.getCurrentCoordinates();

      final response = await dataSource.getAddressFromCoordinates(
        currentCoordinates.latitude,
        currentCoordinates.longitude,
      );

      return LocationMapper.reverseDtoToEntity(
        response,
        fallbackLatitude: currentCoordinates.latitude,
        fallbackLongitude: currentCoordinates.longitude,
      );
    });
  }
}
