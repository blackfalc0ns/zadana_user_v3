import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/delivery_check_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/repo/cart_repository.dart';

@injectable
class CheckDeliveryUseCase {
  const CheckDeliveryUseCase(this._repository);

  final CartRepository _repository;

  Future<ApiResult<DeliveryCheckEntity>> call({
    required String vendorId,
    required String addressId,
  }) {
    return _repository.checkDelivery(
      vendorId: vendorId,
      addressId: addressId,
    );
  }
}
