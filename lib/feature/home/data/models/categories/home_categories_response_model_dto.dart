import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/home/data/models/categories/home_category_item_model_dto.dart';

part 'home_categories_response_model_dto.g.dart';

@JsonSerializable()
class HomeCategoriesResponseModelDto {
  const HomeCategoriesResponseModelDto({
    this.key,
    this.title,
    this.isActive,
    this.theme,
    this.itemsCount,
    this.items,
  });

  factory HomeCategoriesResponseModelDto.fromJson(Map<String, dynamic> json) =>
      _$HomeCategoriesResponseModelDtoFromJson(json);
  final String? key;
  final String? title;

  @JsonKey(name: 'is_active')
  final bool? isActive;

  final String? theme;

  @JsonKey(name: 'items_count')
  final int? itemsCount;

  final List<HomeCategoryItemModelDto>? items;

  Map<String, dynamic> toJson() => _$HomeCategoriesResponseModelDtoToJson(this);
}
