import 'package:json_annotation/json_annotation.dart';

part 'brand_products_item_model_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BrandProductsItemModelDto {
  const BrandProductsItemModelDto({
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
    this.packageTypeNameAr,
    this.packageTypeNameEn,
    this.measurementUnitNameAr,
    this.measurementUnitNameEn,
    this.measurementValue,
    this.displaySizeAr,
    this.displaySizeEn,
  });

  factory BrandProductsItemModelDto.fromJson(Map<String, dynamic> json) =>
      _$BrandProductsItemModelDtoFromJson(json);

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
  final String? packageTypeNameAr;
  final String? packageTypeNameEn;
  final String? measurementUnitNameAr;
  final String? measurementUnitNameEn;
  final double? measurementValue;
  final String? displaySizeAr;
  final String? displaySizeEn;

  Map<String, dynamic> toJson() => _$BrandProductsItemModelDtoToJson(this);
}
