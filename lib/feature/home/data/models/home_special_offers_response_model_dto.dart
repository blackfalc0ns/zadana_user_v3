import 'package:zadana_user_v3/feature/home/data/models/home_special_offer_item_model_dto.dart';

class HomeSpecialOffersResponseModelDto {
  const HomeSpecialOffersResponseModelDto({
    this.key,
    this.title,
    this.isActive,
    this.theme,
    this.itemsCount,
    this.items,
  });

  factory HomeSpecialOffersResponseModelDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return HomeSpecialOffersResponseModelDto(
      key: json['key'] as String?,
      title: json['title'] as String?,
      isActive: json['is_active'] as bool?,
      theme: json['theme'] as String?,
      itemsCount: json['items_count'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (item) => HomeSpecialOfferItemModelDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
  final String? key;
  final String? title;
  final bool? isActive;
  final String? theme;
  final int? itemsCount;
  final List<HomeSpecialOfferItemModelDto>? items;
}
