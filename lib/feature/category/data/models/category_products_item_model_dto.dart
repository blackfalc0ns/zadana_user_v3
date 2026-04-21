import 'package:json_annotation/json_annotation.dart';

part 'category_products_item_model_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryProductsItemModelDto {
  const CategoryProductsItemModelDto({
    this.id,
    this.name,
    this.store,
    this.price,
    this.oldPrice,
    this.imageUrl,
    this.rating,
    this.reviewCount,
    this.discount,
    this.isFavorite,
    this.unit,
    this.isDiscounted,
  });

  factory CategoryProductsItemModelDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryProductsItemModelDtoFromJson(json);

  final String? id;
  final String? name;
  final String? store;
  final double? price;
  final double? oldPrice;
  final String? imageUrl;
  final double? rating;
  final int? reviewCount;
  final String? discount;
  final bool? isFavorite;
  final String? unit;
  final bool? isDiscounted;

  Map<String, dynamic> toJson() => _$CategoryProductsItemModelDtoToJson(this);
}
