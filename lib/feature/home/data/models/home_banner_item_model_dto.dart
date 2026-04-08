import 'package:json_annotation/json_annotation.dart';

part 'home_banner_item_model_dto.g.dart';

@JsonSerializable()
class HomeBannerItemModelDto {
  final String? id;
  final String? tag;
  final String? title;
  final String? subtitle;

  @JsonKey(name: 'action_label')
  final String? actionLabel;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  const HomeBannerItemModelDto({
    this.id,
    this.tag,
    this.title,
    this.subtitle,
    this.actionLabel,
    this.imageUrl,
  });

  factory HomeBannerItemModelDto.fromJson(Map<String, dynamic> json) =>
      _$HomeBannerItemModelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeBannerItemModelDtoToJson(this);
}
