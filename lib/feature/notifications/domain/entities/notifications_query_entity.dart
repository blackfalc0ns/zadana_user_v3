class NotificationsQueryEntity {
  const NotificationsQueryEntity({
    this.page = 1,
    this.perPage = 20,
    this.type,
    this.isRead,
    this.fromUtc,
    this.toUtc,
  });

  final int page;
  final int perPage;
  final String? type;
  final bool? isRead;
  final DateTime? fromUtc;
  final DateTime? toUtc;
}
