import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_categories_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/repo/home_repository.dart';

@injectable
class GetHomeCategoriesUseCase {
  const GetHomeCategoriesUseCase(this._repository);

  final HomeRepository _repository;

  Future<ApiResult<HomeCategoriesEntity>> call() async {
    return _repository.getHomeCategories();
  }
}
