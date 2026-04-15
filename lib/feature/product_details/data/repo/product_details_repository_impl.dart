import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/product_details/data/data_source/product_details_remote_data_source.dart';
import 'package:zadana_user_v3/feature/product_details/data/mapper/product_details_mapper.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_details_entity.dart';
import 'package:zadana_user_v3/feature/product_details/domain/repo/product_details_repository.dart';

@Injectable(as: ProductDetailsRepository)
class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  const ProductDetailsRepositoryImpl(this._remoteDataSource);
  final ProductDetailsRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<ProductDetailsEntity>> getProductDetails(
    String productId,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getProductDetails(productId);
      return response.toEntity();
    });
  }
}
