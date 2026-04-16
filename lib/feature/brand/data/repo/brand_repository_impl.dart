import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/brand/data/data_source/brand_remote_data_source.dart';
import 'package:zadana_user_v3/feature/brand/data/mapper/brand_filters_mapper.dart';
import 'package:zadana_user_v3/feature/brand/data/mapper/brand_products_mapper.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filters_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_products_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_products_request_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/repo/brand_repository.dart';

@Injectable(as: BrandRepository)
class BrandRepositoryImpl implements BrandRepository {
  const BrandRepositoryImpl(this._remoteDataSource);

  final BrandRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<BrandFiltersEntity>> getBrandFilters(String brandId) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getBrandFilters(brandId);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<BrandProductsEntity>> getBrandProducts(
    BrandProductsRequestEntity request,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getBrandProducts(request);
      return response.toEntity(
        BrandModel(
          id: request.brandId,
          name: request.brandName,
          logo: '',
          emoji: request.brandEmoji,
          productCount: 0,
        ),
      );
    });
  }
}
