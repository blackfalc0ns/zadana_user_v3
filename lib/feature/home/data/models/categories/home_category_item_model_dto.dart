import 'package:json_annotation/json_annotation.dart';

part 'home_category_item_model_dto.g.dart';

@JsonSerializable()
class HomeCategoryItemModelDto {
  const HomeCategoryItemModelDto({this.id, this.name, this.imageUrl});

  factory HomeCategoryItemModelDto.fromJson(Map<String, dynamic> json) =>
      _$HomeCategoryItemModelDtoFromJson(json);
  final String? id;
  final String? name;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  Map<String, dynamic> toJson() => _$HomeCategoryItemModelDtoToJson(this);
}
