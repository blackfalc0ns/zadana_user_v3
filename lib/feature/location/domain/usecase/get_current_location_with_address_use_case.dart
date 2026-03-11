import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/domain/repo/location_repo.dart';

@injectable
class GetCurrentLocationWithAddressUseCase {
  final LocationRepository repository;

  GetCurrentLocationWithAddressUseCase(this.repository);

  Future<ApiResult<LocationEntity>> call() {
    return repository.getCurrentLocationWithAddress();
  }
}