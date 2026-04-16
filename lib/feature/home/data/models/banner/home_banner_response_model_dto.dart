import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/home/data/models/banner/home_banner_item_model_dto.dart';

part 'home_banner_response_model_dto.g.dart';

@JsonSerializable()
class HomeBannerResponseModelDto {
  const HomeBannerResponseModelDto({
    this.key,
    this.title,
    this.isActive,
    this.theme,
    this.itemsCount,
    this.items,
  });

  factory HomeBannerResponseModelDto.fromJson(Map<String, dynamic> json) =>
      _$HomeBannerResponseModelDtoFromJson(json);
  final String? key;
  final String? title;

  @JsonKey(name: 'is_active')
  final bool? isActive;

  final String? theme;

  @JsonKey(name: 'items_count')
  final int? itemsCount;

  final List<HomeBannerItemModelDto>? items;

  Map<String, dynamic> toJson() => _$HomeBannerResponseModelDtoToJson(this);
}
