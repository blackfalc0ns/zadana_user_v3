// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_favorite_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddFavoriteResponseDto _$AddFavoriteResponseDtoFromJson(
  Map<String, dynamic> json,
) => AddFavoriteResponseDto(
  message: json['message'] as String? ?? '',
  item: _favoritesItemFromJson(json['item'] as Map<String, dynamic>?),
  summary: _favoritesSummaryFromJson(json['summary'] as Map<String, dynamic>?),
);

Map<String, dynamic> _$AddFavoriteResponseDtoToJson(
  AddFavoriteResponseDto instance,
) => <String, dynamic>{
  'message': instance.message,
  'item': instance.item.toJson(),
  'summary': instance.summary.toJson(),
};
