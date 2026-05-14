import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/repo/category_repository.dart';

@injectable
class GetCategorySubcategoriesUseCase {
  const GetCategorySubcategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  Future<ApiResult<List<CategorySubcategoryItemDto>>> call({
    String? categoryId,
    int? limit,
  }) async {
    return _repository.getCategorySubcategories(categoryId, limit: limit);
  }
}
