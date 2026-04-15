import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_search_entity.dart';
import 'package:zadana_user_v3/feature/location/domain/repo/location_repo.dart';

@injectable
class SearchLocationsUseCase {
  SearchLocationsUseCase(this.repository);
  final LocationRepository repository;

  Future<ApiResult<List<LocationSearchResultEntity>>> call(String query) {
    return repository.searchLocations(query);
  }
}
