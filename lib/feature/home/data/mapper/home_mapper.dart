import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/home/data/models/app_bar/home_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/banner/home_banner_item_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/banner/home_banner_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/best_selling/home_best_selling_item_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/best_selling/home_best_selling_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/brands/home_brand_item_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/brands/home_brands_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/categories/home_categories_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/categories/home_category_item_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/explore_more/home_explore_more_item_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/explore_more/home_explore_more_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/featured/home_featured_item_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/featured/home_featured_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/recommended/home_recommended_item_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/recommended/home_recommended_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/special_offers/home_special_offer_item_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/special_offers/home_special_offers_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_banner_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_banner_item_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_best_selling_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_brands_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_categories_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_category_item_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_explore_more_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_featured_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_recommended_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_response_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_special_offers_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

extension HomeAppBarModelDtoMapper on HomeAppBarModelDto {
  HomeAppBarEntity toEntity() {
    return HomeAppBarEntity(
      fullName: fullName ?? '',
      email: email ?? '',
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

extension HomeCategoriesResponseModelDtoMapper
    on HomeCategoriesResponseModelDto {
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
      showPriceOnCard: showPriceOnCard,
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

extension HomeBrandItemModelDtoMapper on HomeBrandItemModelDto {
  BrandModel toEntity() {
    return BrandModel(
      id: id ?? '',
      name: name ?? '',
      logo: _resolveImageUrl(logo),
      coverImage: _resolveImageUrl(coverImage),
      productCount: productCount ?? 0,
      description: description,
      emoji: _buildBrandFallback(name),
    );
  }
}

extension HomeBrandsResponseModelDtoMapper on HomeBrandsResponseModelDto {
  HomeBrandsEntity toEntity() {
    return HomeBrandsEntity(
      key: key ?? '',
      title: title ?? '',
      isActive: isActive ?? false,
      theme: theme,
      itemsCount: itemsCount ?? 0,
      items: items?.map((item) => item.toEntity()).toList() ?? const [],
    );
  }
}

extension HomeRecommendedItemModelDtoMapper on HomeRecommendedItemModelDto {
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
      showPriceOnCard: showPriceOnCard,
    );
  }
}

extension HomeRecommendedResponseModelDtoMapper
    on HomeRecommendedResponseModelDto {
  HomeRecommendedEntity toEntity() {
    return HomeRecommendedEntity(
      key: key ?? '',
      title: title ?? '',
      isActive: isActive ?? false,
      theme: theme,
      itemsCount: itemsCount ?? 0,
      items: items?.map((item) => item.toEntity()).toList() ?? const [],
    );
  }
}

extension HomeFeaturedItemModelDtoMapper on HomeFeaturedItemModelDto {
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
      showPriceOnCard: showPriceOnCard,
    );
  }
}

extension HomeFeaturedResponseModelDtoMapper on HomeFeaturedResponseModelDto {
  HomeFeaturedEntity toEntity() {
    return HomeFeaturedEntity(
      key: key ?? '',
      title: title ?? '',
      isActive: isActive ?? false,
      theme: theme,
      itemsCount: itemsCount ?? 0,
      items: items?.map((item) => item.toEntity()).toList() ?? const [],
    );
  }
}

extension HomeSpecialOfferItemModelDtoMapper on HomeSpecialOfferItemModelDto {
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
      showPriceOnCard: showPriceOnCard,
    );
  }
}

extension HomeSpecialOffersResponseModelDtoMapper
    on HomeSpecialOffersResponseModelDto {
  HomeSpecialOffersEntity toEntity() {
    return HomeSpecialOffersEntity(
      key: key ?? '',
      title: title ?? '',
      isActive: isActive ?? false,
      theme: theme,
      itemsCount: itemsCount ?? 0,
      items: items?.map((item) => item.toEntity()).toList() ?? const [],
    );
  }
}

extension HomeExploreMoreItemModelDtoMapper on HomeExploreMoreItemModelDto {
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
      showPriceOnCard: showPriceOnCard,
    );
  }
}

extension HomeExploreMoreResponseModelDtoMapper
    on HomeExploreMoreResponseModelDto {
  HomeExploreMoreEntity toEntity() {
    return HomeExploreMoreEntity(
      key: key ?? '',
      title: title ?? '',
      subcategoryId: subcategoryId,
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

String _buildBrandFallback(String? name) {
  if (name == null || name.trim().isEmpty) {
    return 'B';
  }

  return name.trim().substring(0, 1);
}
