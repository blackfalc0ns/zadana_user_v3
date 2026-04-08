import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_banner_item_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_banner_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_best_selling_item_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_best_selling_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_categories_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_category_item_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_banner_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_banner_item_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_best_selling_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_categories_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_category_item_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_response_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

extension HomeAppBarModelDtoMapper on HomeAppBarModelDto {
  HomeAppBarEntity toEntity() {
    return HomeAppBarEntity(
      deliverToLabel: deliverToLabel ?? '',
      location: location ?? '',
      addressLine: addressLine ?? '',
      notificationsCount: notificationsCount ?? 0,
    );
  }
}

extension HomeBannerItemModelDtoMapper on HomeBannerItemModelDto {
  HomeBannerItemEntity toEntity() {
    return HomeBannerItemEntity(
      id: id ?? '',
      tag: tag ?? '',
      title: title ?? '',
      subtitle: subtitle ?? '',
      actionLabel: actionLabel ?? '',
      imageUrl: _resolveImageUrl(imageUrl),
    );
  }
}

extension HomeBannerResponseModelDtoMapper on HomeBannerResponseModelDto {
  HomeBannerEntity toEntity() {
    return HomeBannerEntity(
      key: key ?? '',
      title: title ?? '',
      isActive: isActive ?? false,
      theme: theme,
      itemsCount: itemsCount ?? 0,
      items: items?.map((item) => item.toEntity()).toList() ?? const [],
    );
  }
}

extension HomeCategoryItemModelDtoMapper on HomeCategoryItemModelDto {
  HomeCategoryItemEntity toEntity() {
    return HomeCategoryItemEntity(
      id: id ?? '',
      name: name ?? '',
      imageUrl: _resolveImageUrl(imageUrl),
    );
  }
}

extension HomeCategoriesResponseModelDtoMapper on HomeCategoriesResponseModelDto {
  HomeCategoriesEntity toEntity() {
    return HomeCategoriesEntity(
      key: key ?? '',
      title: title ?? '',
      isActive: isActive ?? false,
      theme: theme,
      itemsCount: itemsCount ?? 0,
      items: items?.map((item) => item.toEntity()).toList() ?? const [],
    );
  }
}

extension HomeBestSellingItemModelDtoMapper on HomeBestSellingItemModelDto {
  ProductModel toEntity() {
    return ProductModel(
      id: id ?? '',
      name: name ?? '',
      store: store ?? '',
      price: price ?? 0,
      oldPrice: oldPrice,
      imageUrl: _resolveImageUrl(imageUrl),
      rating: rating,
      reviewCount: reviewCount,
      discount: discount,
      isFavorite: isFavorite ?? false,
      unit: unit,
      isDiscounted: isDiscounted ?? false,
    );
  }
}

extension HomeBestSellingResponseModelDtoMapper
    on HomeBestSellingResponseModelDto {
  HomeBestSellingEntity toEntity() {
    return HomeBestSellingEntity(
      key: key ?? '',
      title: title ?? '',
      isActive: isActive ?? false,
      theme: theme,
      itemsCount: itemsCount ?? 0,
      items: items?.map((item) => item.toEntity()).toList() ?? const [],
    );
  }
}

String _resolveImageUrl(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return '';
  }

  final uri = Uri.tryParse(imageUrl);
  if (uri != null && uri.hasScheme) {
    return imageUrl;
  }

  return Uri.parse(NetworkConstants.baseUrl).resolve(imageUrl).toString();
}
