// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_favorite_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveFavoriteResponseDto _$RemoveFavoriteResponseDtoFromJson(
  Map<String, dynamic> json,
) => RemoveFavoriteResponseDto(
  message: json['message'] as String? ?? '',
  summary: _favoritesSummaryFromJson(json['summary'] as Map<String, dynamic>?),
);

Map<String, dynamic> _$RemoveFavoriteResponseDtoToJson(
  RemoveFavoriteResponseDto instance,
) => <String, dynamic>{
  'message': instance.message,
  'summary': instance.summary.toJson(),
};
