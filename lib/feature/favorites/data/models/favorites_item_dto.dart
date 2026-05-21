import 'package:json_annotation/json_annotation.dart';

part 'favorites_item_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FavoritesItemDto {
  const FavoritesItemDto({
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
    this.showPriceOnCard = true,
  });

  factory FavoritesItemDto.fromJson(Map<String, dynamic> json) =>
      _$FavoritesItemDtoFromJson(json);

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
  final bool showPriceOnCard;

  Map<String, dynamic> toJson() => _$FavoritesItemDtoToJson(this);
}
