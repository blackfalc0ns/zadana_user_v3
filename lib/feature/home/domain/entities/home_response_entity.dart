class HomeAppBarEntity {
  const HomeAppBarEntity({
    required this.fullName,
    required this.email,
    required this.profilePhotoUrl,
    required this.deliverToLabel,
    required this.location,
    required this.addressLine,
    required this.notificationsCount,
  });

  const HomeAppBarEntity.empty()
    : fullName = '',
      email = '',
      profilePhotoUrl = null,
      deliverToLabel = '',
      location = '',
      addressLine = '',
      notificationsCount = 0;
  final String fullName;
  final String email;
  final String? profilePhotoUrl;
  final String deliverToLabel;
  final String location;
  final String addressLine;
  final int notificationsCount;
}
