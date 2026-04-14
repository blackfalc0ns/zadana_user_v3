import 'package:zadana_user_v3/feature/addresses/data/models/add_customer_address_request_dto.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/customer_address_item_dto.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/update_customer_address_request_dto.dart';

abstract class CustomerAddressesRemoteDataSource {
  Future<List<CustomerAddressItemDto>> getCustomerAddresses();

  Future<CustomerAddressItemDto> addCustomerAddress(
    AddCustomerAddressRequestDto request,
  );

  Future<bool> updateCustomerAddress(
    String addressId,
    UpdateCustomerAddressRequestDto request,
  );

  Future<bool> setCustomerAddressAsDefault(String addressId);

  Future<bool> deleteCustomerAddress(String addressId);
}
