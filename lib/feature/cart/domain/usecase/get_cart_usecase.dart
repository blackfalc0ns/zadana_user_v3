import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/get_cart_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/repo/cart_repository.dart';

@injectable
class GetCartUseCase {
  const GetCartUseCase(this._repository);

  final CartRepository _repository;

  Future<ApiResult<GetCartResponseEntity>> call({
    String? vendorId,
    int limit = 20,
    int offset = 0,
  }) {
    return _repository.getCart(
      vendorId: vendorId,
      limit: limit,
      offset: offset,
    );
  }
}
