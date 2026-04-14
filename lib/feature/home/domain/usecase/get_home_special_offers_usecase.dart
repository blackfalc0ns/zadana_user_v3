import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_special_offers_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/repo/home_repository.dart';

@injectable
class GetHomeSpecialOffersUseCase {
  const GetHomeSpecialOffersUseCase(this._repository);

  final HomeRepository _repository;

  Future<ApiResult<HomeSpecialOffersEntity>> call({int? take}) async {
    return _repository.getHomeSpecialOffers(take: take);
  }
}
