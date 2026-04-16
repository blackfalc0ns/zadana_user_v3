import 'package:zadana_user_v3/feature/home/data/models/app_bar/home_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/banner/home_banner_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/best_selling/home_best_selling_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/brands/home_brands_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/categories/home_categories_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/explore_more/home_explore_more_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/featured/home_featured_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/recommended/home_recommended_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/special_offers/home_special_offers_response_model_dto.dart';

abstract class HomeRemoteDataSource {
  Future<HomeAppBarModelDto> getHomeAppBar();
  Future<HomeBannerResponseModelDto> getHomeBanners();
  Future<HomeCategoriesResponseModelDto> getHomeCategories();
  Future<HomeBestSellingResponseModelDto> getHomeBestSelling({int? take});
  Future<HomeBrandsResponseModelDto> getHomeBrands({int? take});
  Future<HomeRecommendedResponseModelDto> getHomeRecommended({int? take});
  Future<HomeFeaturedResponseModelDto> getHomeFeaturedProducts();
  Future<HomeSpecialOffersResponseModelDto> getHomeSpecialOffers({int? take});
  Future<List<HomeExploreMoreResponseModelDto>> getHomeExploreMore();
}
