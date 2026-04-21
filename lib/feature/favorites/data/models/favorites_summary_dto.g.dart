// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoritesSummaryDto _$FavoritesSummaryDtoFromJson(Map<String, dynamic> json) =>
    FavoritesSummaryDto(
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FavoritesSummaryDtoToJson(
  FavoritesSummaryDto instance,
) => <String, dynamic>{'items_count': instance.itemsCount};
