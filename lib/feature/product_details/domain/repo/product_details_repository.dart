import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_details_entity.dart';

abstract class ProductDetailsRepository {
  Future<ApiResult<ProductDetailsEntity>> getProductDetails(String productId);
}
