import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/repo/category_repository.dart';

@injectable
class GetCategoryFiltersUseCase {
  const GetCategoryFiltersUseCase(this._repository);

  final CategoryRepository _repository;

  Future<ApiResult<CategoryFiltersResponseModelDto>> call(
    String categoryId,
  ) async {
    return _repository.getCategoryFilters(categoryId);
  }
}
