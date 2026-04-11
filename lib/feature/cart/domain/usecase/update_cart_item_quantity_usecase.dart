import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/update_cart_item_quantity_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/repo/cart_repository.dart';

@injectable
class UpdateCartItemQuantityUseCase {
  const UpdateCartItemQuantityUseCase(this._repository);

  final CartRepository _repository;

  Future<ApiResult<AddCartItemResponseEntity>> call({
    required String itemId,
    required UpdateCartItemQuantityRequestEntity request,
  }) {
    return _repository.updateCartItemQuantity(itemId: itemId, request: request);
  }
}
