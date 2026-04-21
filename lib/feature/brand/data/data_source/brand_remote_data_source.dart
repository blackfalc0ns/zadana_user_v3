import 'package:zadana_user_v3/feature/brand/data/models/filters/brand_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/products/brand_products_response_model_dto.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_products_request_entity.dart';

abstract class BrandRemoteDataSource {
  Future<BrandFiltersResponseModelDto> getBrandFilters(String brandId);

  Future<BrandProductsResponseModelDto> getBrandProducts(
    BrandProductsRequestEntity request,
  );
}
