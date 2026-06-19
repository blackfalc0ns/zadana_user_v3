import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/favorites_response_entity.dart';

@injectable
class GetFavoritesUseCase {
  const GetFavoritesUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<ApiResult<FavoritesResponseEntity>> call({
    int page = 1,
    int perPage = 20,
  }) {
    return _repository.getFavorites(page: page, perPage: perPage);
  }
}
