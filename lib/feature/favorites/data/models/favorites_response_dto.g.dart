// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoritesResponseDto _$FavoritesResponseDtoFromJson(
  Map<String, dynamic> json,
) => FavoritesResponseDto(
  items: _favoritesItemsFromJson(json['items'] as List?),
  summary: _favoritesSummaryFromJson(json['summary'] as Map<String, dynamic>?),
);

Map<String, dynamic> _$FavoritesResponseDtoToJson(
  FavoritesResponseDto instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'summary': instance.summary.toJson(),
};
