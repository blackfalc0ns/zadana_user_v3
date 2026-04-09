import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_details_entity.dart';
import 'package:zadana_user_v3/feature/product_details/domain/repo/product_details_repository.dart';

@injectable
class ProductDetailsUseCase {
  final ProductDetailsRepository _repository;

  const ProductDetailsUseCase(this._repository);

  Future<ApiResult<ProductDetailsEntity>> getProductDetails(
    String productId,
  ) async {
    return _repository.getProductDetails(productId);
  }
}
