import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/addresses/domain/repo/customer_addresses_repository.dart';

@injectable
class SetCustomerAddressAsDefaultUseCase {
  const SetCustomerAddressAsDefaultUseCase(this._repository);

  final CustomerAddressesRepository _repository;

  Future<ApiResult<String>> call(String addressId) {
    return _repository.setCustomerAddressAsDefault(addressId);
  }
}
