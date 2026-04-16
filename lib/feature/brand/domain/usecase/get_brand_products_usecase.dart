import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_products_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_products_request_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/repo/brand_repository.dart';

@injectable
class GetBrandProductsUseCase {
  const GetBrandProductsUseCase(this._repository);

  final BrandRepository _repository;

  Future<ApiResult<BrandProductsEntity>> call(BrandProductsRequestEntity request) {
    return _repository.getBrandProducts(request);
  }
}
