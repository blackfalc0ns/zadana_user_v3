import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/paginated_products_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/shopping_products_request_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/repo/category_repository.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

@injectable
class GetShoppingProductsUseCase {
  const GetShoppingProductsUseCase(this._repository);

  final CategoryRepository _repository;

  Future<ApiResult<List<ProductModel>>> call(
    ShoppingProductsRequestEntity request,
  ) async {
    return _repository.getShoppingProducts(request);
  }

  Future<ApiResult<PaginatedProductsEntity>> callPaginated(
    ShoppingProductsRequestEntity request,
  ) async {
    return _repository.getShoppingProductsPaginated(request);
  }
}
