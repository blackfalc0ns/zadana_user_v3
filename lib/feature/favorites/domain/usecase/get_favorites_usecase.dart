import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/favorites_response_entity.dart';

@injectable
class GetFavoritesUseCase {
  const GetFavoritesUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<ApiResult<FavoritesResponseEntity>> call({
    int limit = 20,
    int offset = 0,
  }) {
    return _repository.getFavorites(limit: limit, offset: offset);
  }
}
