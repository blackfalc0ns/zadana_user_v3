import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_recommended_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/repo/home_repository.dart';

@injectable
class GetHomeRecommendedUseCase {
  const GetHomeRecommendedUseCase(this._repository);

  final HomeRepository _repository;

  Future<ApiResult<HomeRecommendedEntity>> call({int? take}) async {
    return _repository.getHomeRecommended(take: take);
  }
}
