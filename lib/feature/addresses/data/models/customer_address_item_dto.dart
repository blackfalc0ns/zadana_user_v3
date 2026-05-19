import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';

part 'customer_address_item_dto.g.dart';

@JsonSerializable()
class CustomerAddressItemDto {
  const CustomerAddressItemDto({
    required this.id,
    required this.contactName,
    required this.contactPhone,
    required this.addressLine,
    required this.label,
    required this.buildingNo,
    required this.floorNo,
    required this.apartmentNo,
    required this.city,
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
  });

  factory CustomerAddressItemDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerAddressItemDtoFromJson(json);

  final String id;
  final String contactName;
  final String contactPhone;
  final String addressLine;
  final String label;
  final String? buildingNo;
  final String? floorNo;
  final String? apartmentNo;
  final String city;
  @JsonKey(defaultValue: '')
  final String area;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  Map<String, dynamic> toJson() => _$CustomerAddressItemDtoToJson(this);
}

extension CustomerAddressItemDtoMapper on CustomerAddressItemDto {
  CustomerAddressEntity toEntity() {
    return CustomerAddressEntity(
      id: id,
      contactName: contactName,
      contactPhone: contactPhone,
      addressLine: addressLine,
      label: label,
      buildingNo: buildingNo,
      floorNo: floorNo,
      apartmentNo: apartmentNo,
      city: city,
      area: area,
      latitude: latitude,
      longitude: longitude,
      isDefault: isDefault,
    );
  }
}
