import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/remove_favorite_response_entity.dart';

@injectable
class RemoveFavoriteUseCase {
  const RemoveFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<ApiResult<RemoveFavoriteResponseEntity>> call(String productId) {
    return _repository.removeFavorite(productId);
  }
}
