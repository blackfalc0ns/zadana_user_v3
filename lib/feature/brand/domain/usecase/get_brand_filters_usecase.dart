import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filters_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/repo/brand_repository.dart';

@injectable
class GetBrandFiltersUseCase {
  const GetBrandFiltersUseCase(this._repository);

  final BrandRepository _repository;

  Future<ApiResult<BrandFiltersEntity>> call(String brandId) {
    return _repository.getBrandFilters(brandId);
  }
}
