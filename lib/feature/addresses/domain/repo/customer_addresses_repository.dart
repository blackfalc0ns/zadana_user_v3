import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/add_customer_address_request_dto.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/update_customer_address_request_dto.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';

abstract class CustomerAddressesRepository {
  Future<ApiResult<List<CustomerAddressEntity>>> getCustomerAddresses();

  Future<ApiResult<CustomerAddressEntity>> addCustomerAddress(
    AddCustomerAddressRequestDto request,
  );

  Future<ApiResult<String>> updateCustomerAddress(
    String addressId,
    UpdateCustomerAddressRequestDto request,
  );

  Future<ApiResult<String>> setCustomerAddressAsDefault(String addressId);

  Future<ApiResult<String>> deleteCustomerAddress(String addressId);
}
