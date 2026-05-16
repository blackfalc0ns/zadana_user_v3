// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_products_item_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryProductsItemModelDto _$CategoryProductsItemModelDtoFromJson(
  Map<String, dynamic> json,
) => CategoryProductsItemModelDto(
  id: json['id'] as String?,
  name: json['name'] as String?,
  store: json['store'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  oldPrice: (json['old_price'] as num?)?.toDouble(),
  imageUrl: json['image_url'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  reviewCount: (json['review_count'] as num?)?.toInt(),
  discount: json['discount'] as String?,
  isFavorite: json['is_favorite'] as bool?,
  unit: json['unit'] as String?,
  isDiscounted: json['is_discounted'] as bool?,
  packageTypeNameAr: json['package_type_name_ar'] as String?,
  packageTypeNameEn: json['package_type_name_en'] as String?,
  measurementUnitNameAr: json['measurement_unit_name_ar'] as String?,
  measurementUnitNameEn: json['measurement_unit_name_en'] as String?,
  measurementValue: (json['measurement_value'] as num?)?.toDouble(),
  displaySizeAr: json['display_size_ar'] as String?,
  displaySizeEn: json['display_size_en'] as String?,
);

Map<String, dynamic> _$CategoryProductsItemModelDtoToJson(
  CategoryProductsItemModelDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'store': instance.store,
  'price': instance.price,
  'old_price': instance.oldPrice,
  'image_url': instance.imageUrl,
  'rating': instance.rating,
  'review_count': instance.reviewCount,
  'discount': instance.discount,
  'is_favorite': instance.isFavorite,
  'unit': instance.unit,
  'is_discounted': instance.isDiscounted,
  'package_type_name_ar': instance.packageTypeNameAr,
  'package_type_name_en': instance.packageTypeNameEn,
  'measurement_unit_name_ar': instance.measurementUnitNameAr,
  'measurement_unit_name_en': instance.measurementUnitNameEn,
  'measurement_value': instance.measurementValue,
  'display_size_ar': instance.displaySizeAr,
  'display_size_en': instance.displaySizeEn,
};
