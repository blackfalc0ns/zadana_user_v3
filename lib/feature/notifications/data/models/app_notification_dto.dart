import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/app_notification_entity.dart';

part 'app_notification_dto.g.dart';

@JsonSerializable()
class AppNotificationDto {
  const AppNotificationDto({
    required this.id,
    this.titleAr,
    this.titleEn,
    this.bodyAr,
    this.bodyEn,
    this.type,
    this.referenceId,
    this.data,
    this.dataObject,
    this.isRead,
    this.createdAtUtc,
  });

  factory AppNotificationDto.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationDtoFromJson(json);

  final String id;
  final String? titleAr;
  final String? titleEn;
  final String? bodyAr;
  final String? bodyEn;
  final String? type;
  final String? referenceId;
  final String? data;
  final Map<String, dynamic>? dataObject;
  final bool? isRead;
  final String? createdAtUtc;

  Map<String, dynamic> toJson() => _$AppNotificationDtoToJson(this);

  AppNotificationEntity toEntity() {
    return AppNotificationEntity(
      id: id,
      titleAr: titleAr ?? '',
      titleEn: titleEn ?? '',
      bodyAr: bodyAr ?? '',
      bodyEn: bodyEn ?? '',
      type: type,
      referenceId: referenceId,
      data: data,
      dataObject: dataObject ?? _decodeRawData(data),
      isRead: isRead ?? false,
      createdAtUtc: DateTime.tryParse(createdAtUtc ?? '') ?? DateTime.now().toUtc(),
    );
  }

  static Map<String, dynamic>? _decodeRawData(String? rawData) {
    if (rawData == null || rawData.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawData);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}
