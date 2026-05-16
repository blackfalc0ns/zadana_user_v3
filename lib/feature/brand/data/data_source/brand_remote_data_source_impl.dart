import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/brand/data/data_source/brand_remote_data_source.dart';
import 'package:zadana_user_v3/feature/brand/data/models/filters/brand_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/products/brand_products_response_model_dto.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_products_request_entity.dart';

@Injectable(as: BrandRemoteDataSource)
class BrandRemoteDataSourceImpl implements BrandRemoteDataSource {
  const BrandRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BrandFiltersResponseModelDto> getBrandFilters(String brandId) {
    return _apiServices.getBrandFilters(brandId);
  }

  @override
  Future<BrandProductsResponseModelDto> getBrandProducts(
    BrandProductsRequestEntity request,
  ) {
    return _apiServices.getBrandProducts(
      request.brandId,
      request.categoryId,
      request.subcategoryId,
      request.unitId,
      request.packageTypeId,
      request.measurementUnitId,
      request.measurementValue,
      request.minPrice,
      request.maxPrice,
      request.sort,
      request.page,
      request.perPage,
    );
  }
}
