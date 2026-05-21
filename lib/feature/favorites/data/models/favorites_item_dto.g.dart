// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoritesItemDto _$FavoritesItemDtoFromJson(Map<String, dynamic> json) =>
    FavoritesItemDto(
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
      showPriceOnCard: json['show_price_on_card'] as bool? ?? true,
    );

Map<String, dynamic> _$FavoritesItemDtoToJson(FavoritesItemDto instance) =>
    <String, dynamic>{
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
      'show_price_on_card': instance.showPriceOnCard,
    };
