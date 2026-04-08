// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_banner_item_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeBannerItemModelDto _$HomeBannerItemModelDtoFromJson(
  Map<String, dynamic> json,
) => HomeBannerItemModelDto(
  id: json['id'] as String?,
  tag: json['tag'] as String?,
  title: json['title'] as String?,
  subtitle: json['subtitle'] as String?,
  actionLabel: json['action_label'] as String?,
  imageUrl: json['image_url'] as String?,
);

Map<String, dynamic> _$HomeBannerItemModelDtoToJson(
  HomeBannerItemModelDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'tag': instance.tag,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'action_label': instance.actionLabel,
  'image_url': instance.imageUrl,
};
