class PickupBranchOptionEntity {
  const PickupBranchOptionEntity({
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

  final String id;
  final String name;
  final String? addressLine;
  final String? city;
  final String? address;
  final String? hoursToday;
  final bool isPrimary;
  final bool canFulfillCart;
  final int missingItemsCount;

  String get displayAddress {
    if (address != null && address!.trim().isNotEmpty) {
      return address!.trim();
    }

    final parts = <String>[
      if (addressLine != null && addressLine!.trim().isNotEmpty)
        addressLine!.trim(),
      if (city != null && city!.trim().isNotEmpty) city!.trim(),
    ];
    return parts.join(', ');
  }
}
