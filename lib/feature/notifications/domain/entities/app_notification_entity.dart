class AppNotificationEntity {
  const AppNotificationEntity({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    required this.type,
    required this.referenceId,
    required this.data,
    required this.dataObject,
    required this.isRead,
    required this.createdAtUtc,
  });

  final String id;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final String? type;
  final String? referenceId;
  final String? data;
  final Map<String, dynamic>? dataObject;
  final bool isRead;
  final DateTime createdAtUtc;

  AppNotificationEntity copyWith({
    String? id,
    String? titleAr,
    String? titleEn,
    String? bodyAr,
    String? bodyEn,
    Object? type = _unset,
    Object? referenceId = _unset,
    Object? data = _unset,
    Object? dataObject = _unset,
    bool? isRead,
    DateTime? createdAtUtc,
  }) {
    return AppNotificationEntity(
      id: id ?? this.id,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      bodyAr: bodyAr ?? this.bodyAr,
      bodyEn: bodyEn ?? this.bodyEn,
      type: identical(type, _unset) ? this.type : type as String?,
      referenceId: identical(referenceId, _unset)
          ? this.referenceId
          : referenceId as String?,
      data: identical(data, _unset) ? this.data : data as String?,
      dataObject: identical(dataObject, _unset)
          ? this.dataObject
          : dataObject as Map<String, dynamic>?,
      isRead: isRead ?? this.isRead,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    );
  }

  static const _unset = Object();
}
