import 'package:zadana_user_v3/feature/home/data/models/home_banner_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_best_selling_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_brands_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_categories_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_explore_more_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_featured_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_recommended_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_special_offers_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_response_model_dto.dart';

abstract class HomeRemoteDataSource {
  Future<HomeAppBarModelDto> getHomeAppBar();
  Future<HomeBannerResponseModelDto> getHomeBanners();
  Future<HomeCategoriesResponseModelDto> getHomeCategories();
  Future<HomeBestSellingResponseModelDto> getHomeBestSelling();
  Future<HomeBrandsResponseModelDto> getHomeBrands();
  Future<HomeRecommendedResponseModelDto> getHomeRecommended();
  Future<HomeFeaturedResponseModelDto> getHomeFeaturedProducts();
  Future<HomeSpecialOffersResponseModelDto> getHomeSpecialOffers();
  Future<HomeExploreMoreResponseModelDto> getHomeExploreMore();
}
