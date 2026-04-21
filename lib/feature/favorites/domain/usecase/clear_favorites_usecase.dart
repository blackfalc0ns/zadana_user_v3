import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/favorites/domain/entities/clear_favorites_response_entity.dart';

@injectable
class ClearFavoritesUseCase {
  const ClearFavoritesUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<ApiResult<ClearFavoritesResponseEntity>> call({
    Iterable<String> productIds = const [],
  }) async {
    final result = await _repository.clearFavorites();

    if (result is ApiSuccessResult<ClearFavoritesResponseEntity>) {
      _repository.emitFavoriteMutation(
        productIds: productIds,
        isFavorite: false,
      );
    }

    return result;
  }
}
