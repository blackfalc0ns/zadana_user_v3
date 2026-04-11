import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendors_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/repo/cart_repository.dart';

@injectable
class GetCartVendorsUseCase {
  const GetCartVendorsUseCase(this._repository);

  final CartRepository _repository;

  Future<ApiResult<CartVendorsEntity>> call() {
    return _repository.getCartVendors();
  }
}
