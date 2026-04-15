import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/search/data/data_source/product_search_remote_data_source.dart';
import 'package:zadana_user_v3/feature/search/data/models/product_search_response_dto.dart';

@Injectable(as: ProductSearchRemoteDataSource)
class ProductSearchRemoteDataSourceImpl
    implements ProductSearchRemoteDataSource {
  const ProductSearchRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<ProductSearchResponseDto> searchProducts({
    required String query,
    String? categoryId,
    String? brandId,
    double? minPrice,
    double? maxPrice,
    String? sort,
    int? page,
    int? perPage,
  }) {
    return _apiServices.searchProducts(
      query,
      categoryId,
      brandId,
      minPrice,
      maxPrice,
      sort,
      page,
      perPage,
    );
  }
}
