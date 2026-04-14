import 'package:zadana_user_v3/feature/search/data/models/product_search_response_dto.dart';

abstract class ProductSearchRemoteDataSource {
  Future<ProductSearchResponseDto> searchProducts({
    required String query,
    String? categoryId,
    String? brandId,
    double? minPrice,
    double? maxPrice,
    String? sort,
    int? page,
    int? perPage,
  });
}
