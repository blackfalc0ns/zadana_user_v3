import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/update_customer_address_request_dto.dart';
import 'package:zadana_user_v3/feature/addresses/domain/repo/customer_addresses_repository.dart';

@injectable
class UpdateCustomerAddressUseCase {
  const UpdateCustomerAddressUseCase(this._repository);

  final CustomerAddressesRepository _repository;

  Future<ApiResult<String>> call(
    String addressId,
    UpdateCustomerAddressRequestDto request,
  ) {
    return _repository.updateCustomerAddress(addressId, request);
  }
}
