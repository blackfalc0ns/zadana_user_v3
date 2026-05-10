class HomeAppBarEntity {
  const HomeAppBarEntity({
    required this.fullName,
    required this.email,
    required this.deliverToLabel,
    required this.location,
    required this.addressLine,
    required this.notificationsCount,
  });

  const HomeAppBarEntity.empty()
    : fullName = '',
      email = '',
      deliverToLabel = '',
      location = '',
      addressLine = '',
      notificationsCount = 0;
  final String fullName;
  final String email;
  final String deliverToLabel;
  final String location;
  final String addressLine;
  final int notificationsCount;
}
