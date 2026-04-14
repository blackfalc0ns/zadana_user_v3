import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';

sealed class CustomerAddressesEvent {
  const CustomerAddressesEvent();
}

class CustomerAddressesLoadEvent extends CustomerAddressesEvent {
  const CustomerAddressesLoadEvent();
}

class CustomerAddressesRetryEvent extends CustomerAddressesEvent {
  const CustomerAddressesRetryEvent();
}

class CustomerAddressDeleteEvent extends CustomerAddressesEvent {
  const CustomerAddressDeleteEvent(this.addressId);

  final String addressId;
}

class CustomerAddressSetDefaultEvent extends CustomerAddressesEvent {
  const CustomerAddressSetDefaultEvent(this.addressId);

  final String addressId;
}

class CustomerAddressUpdateEvent extends CustomerAddressesEvent {
  const CustomerAddressUpdateEvent({
    required this.originalAddress,
    required this.updatedLocation,
  });

  final CustomerAddressEntity originalAddress;
  final LocationEntity updatedLocation;
}
