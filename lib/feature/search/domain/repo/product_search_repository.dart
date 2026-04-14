import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_entity.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_request_entity.dart';

abstract class ProductSearchRepository {
  Future<ApiResult<ProductSearchEntity>> searchProducts(
    ProductSearchRequestEntity request,
  );
}
