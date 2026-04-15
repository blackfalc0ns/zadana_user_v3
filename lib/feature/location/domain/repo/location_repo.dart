import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_search_entity.dart';

abstract class LocationRepository {
  Future<ApiResult<List<LocationSearchResultEntity>>> searchLocations(
    String query,
  );

  Future<ApiResult<LocationEntity>> getAddressFromCoordinates(
    double latitude,
    double longitude,
  );

  Future<ApiResult<LocationEntity>> getCurrentLocationWithAddress();
}
