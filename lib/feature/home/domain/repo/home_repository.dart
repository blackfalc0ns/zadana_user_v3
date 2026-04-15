import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_banner_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_best_selling_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_brands_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_categories_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_explore_more_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_featured_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_recommended_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_response_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_special_offers_entity.dart';

abstract class HomeRepository {
  Future<ApiResult<HomeAppBarEntity>> getHomeAppBar();
  Future<ApiResult<HomeBannerEntity>> getHomeBanners();
  Future<ApiResult<HomeCategoriesEntity>> getHomeCategories();
  Future<ApiResult<HomeBestSellingEntity>> getHomeBestSelling({int? take});
  Future<ApiResult<HomeBrandsEntity>> getHomeBrands({int? take});
  Future<ApiResult<HomeRecommendedEntity>> getHomeRecommended({int? take});
  Future<ApiResult<HomeFeaturedEntity>> getHomeFeaturedProducts();
  Future<ApiResult<HomeSpecialOffersEntity>> getHomeSpecialOffers({int? take});
  Future<ApiResult<List<HomeExploreMoreEntity>>> getHomeExploreMore();
}
