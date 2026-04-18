import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_products_request_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/repo/category_repository.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

@injectable
class GetCategoryProductsUseCase {
  const GetCategoryProductsUseCase(this._repository);

  final CategoryRepository _repository;

  Future<ApiResult<List<ProductModel>>> call(
    CategoryProductsRequestEntity request,
  ) async {
    return _repository.getCategoryProducts(request);
  }
}
