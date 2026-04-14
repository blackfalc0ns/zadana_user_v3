import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/search/data/data_source/product_search_remote_data_source.dart';
import 'package:zadana_user_v3/feature/search/data/mapper/product_search_mapper.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_entity.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_request_entity.dart';
import 'package:zadana_user_v3/feature/search/domain/repo/product_search_repository.dart';

@Injectable(as: ProductSearchRepository)
class ProductSearchRepositoryImpl implements ProductSearchRepository {
  const ProductSearchRepositoryImpl(this._remoteDataSource);

  final ProductSearchRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<ProductSearchEntity>> searchProducts(
    ProductSearchRequestEntity request,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.searchProducts(
        query: request.query,
        categoryId: request.categoryId,
        brandId: request.brandId,
        minPrice: request.minPrice,
        maxPrice: request.maxPrice,
        sort: request.sort,
        page: request.page,
        perPage: request.perPage,
      );
      return response.toEntity();
    });
  }
}
