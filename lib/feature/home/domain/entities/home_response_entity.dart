class HomeAppBarEntity {
  final String deliverToLabel;
  final String location;
  final String addressLine;
  final int notificationsCount;

  const HomeAppBarEntity({
    required this.deliverToLabel,
    required this.location,
    required this.addressLine,
    required this.notificationsCount,
  });

  const HomeAppBarEntity.empty()
      : deliverToLabel = '',
        location = '',
        addressLine = '',
        notificationsCount = 0;
}
