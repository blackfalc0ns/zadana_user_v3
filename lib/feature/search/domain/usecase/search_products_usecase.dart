import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_entity.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_request_entity.dart';
import 'package:zadana_user_v3/feature/search/domain/repo/product_search_repository.dart';

@injectable
class SearchProductsUseCase {
  const SearchProductsUseCase(this._repository);

  final ProductSearchRepository _repository;

  Future<ApiResult<ProductSearchEntity>> call(
    ProductSearchRequestEntity request,
  ) {
    return _repository.searchProducts(request);
  }
}
