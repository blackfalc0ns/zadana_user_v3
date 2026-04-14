import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_best_selling_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/repo/home_repository.dart';

@injectable
class GetHomeBestSellingUseCase {
  const GetHomeBestSellingUseCase(this._repository);

  final HomeRepository _repository;

  Future<ApiResult<HomeBestSellingEntity>> call({int? take}) async {
    return _repository.getHomeBestSelling(take: take);
  }
}
