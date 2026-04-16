import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filters_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_products_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_products_request_entity.dart';

abstract class BrandRepository {
  Future<ApiResult<BrandFiltersEntity>> getBrandFilters(String brandId);

  Future<ApiResult<BrandProductsEntity>> getBrandProducts(
    BrandProductsRequestEntity request,
  );
}
