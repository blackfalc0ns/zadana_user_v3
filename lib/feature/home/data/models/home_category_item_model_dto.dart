import 'package:json_annotation/json_annotation.dart';

part 'home_category_item_model_dto.g.dart';

@JsonSerializable()
class HomeCategoryItemModelDto {
  final String? id;
  final String? name;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  const HomeCategoryItemModelDto({
    this.id,
    this.name,
    this.imageUrl,
  });

  factory HomeCategoryItemModelDto.fromJson(Map<String, dynamic> json) =>
      _$HomeCategoryItemModelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeCategoryItemModelDtoToJson(this);
}
