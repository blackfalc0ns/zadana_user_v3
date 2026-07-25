import 'package:zadana_user_v3/feature/payment/domain/entities/pickup_branch_option_entity.dart';

class PickupBranchOptionsDto {
  const PickupBranchOptionsDto({
    required this.vendorId,
    required this.city,
    required this.branches,
  });

  factory PickupBranchOptionsDto.fromJson(Map<String, dynamic> json) {
    return PickupBranchOptionsDto(
      vendorId: json['vendor_id']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      branches: _asList(
        json['branches'],
      ).map((item) => PickupBranchOptionDto.fromJson(_asMap(item))).toList(),
    );
  }

  final String vendorId;
  final String city;
  final List<PickupBranchOptionDto> branches;

  List<PickupBranchOptionEntity> toEntity() {
    return branches.map((item) => item.toEntity()).toList();
  }
}

class PickupBranchOptionDto {
  const PickupBranchOptionDto({
    required this.id,
    required this.name,
    this.addressLine,
    this.city,
    this.address,
    this.hoursToday,
    this.isPrimary = false,
    this.canFulfillCart = false,
    this.missingItemsCount = 0,
  });

  factory PickupBranchOptionDto.fromJson(Map<String, dynamic> json) {
    return PickupBranchOptionDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      addressLine: json['address_line']?.toString(),
      city: json['city']?.toString(),
      address: json['address']?.toString(),
      hoursToday: json['hours_today']?.toString(),
      isPrimary: json['is_primary'] == true,
      canFulfillCart: json['can_fulfill_cart'] == true,
      missingItemsCount: _asInt(json['missing_items_count']),
    );
  }

  final String id;
  final String name;
  final String? addressLine;
  final String? city;
  final String? address;
  final String? hoursToday;
  final bool isPrimary;
  final bool canFulfillCart;
  final int missingItemsCount;

  PickupBranchOptionEntity toEntity() {
    return PickupBranchOptionEntity(
      id: id,
      name: name,
      addressLine: addressLine,
      city: city,
      address: address,
      hoursToday: hoursToday,
      isPrimary: isPrimary,
      canFulfillCart: canFulfillCart,
      missingItemsCount: missingItemsCount,
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }
  return <String, dynamic>{};
}

List<dynamic> _asList(dynamic value) {
  return value is List ? value : const [];
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
