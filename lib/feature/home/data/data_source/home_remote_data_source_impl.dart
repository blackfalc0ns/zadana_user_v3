import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/home/data/data_source/home_remote_data_source.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_banner_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_best_selling_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_brands_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_categories_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_explore_more_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_featured_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_recommended_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_special_offers_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_response_model_dto.dart';

@Injectable(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiServices _apiServices;

  const HomeRemoteDataSourceImpl(this._apiServices);

  @override
  Future<HomeAppBarModelDto> getHomeAppBar() {
    return _apiServices.getHomeAppBar();
  }

  @override
  Future<HomeBannerResponseModelDto> getHomeBanners() {
    return _apiServices.getHomeBanners();
  }

  @override
  Future<HomeCategoriesResponseModelDto> getHomeCategories() {
    return _apiServices.getHomeCategories();
  }

  @override
  Future<HomeBestSellingResponseModelDto> getHomeBestSelling({int? take}) {
    return _apiServices.getHomeBestSelling(take);
  }

  @override
  Future<HomeBrandsResponseModelDto> getHomeBrands({int? take}) {
    return _apiServices.getHomeBrands(take);
  }

  @override
  Future<HomeRecommendedResponseModelDto> getHomeRecommended({int? take}) {
    return _apiServices.getHomeRecommended(take);
  }

  @override
  Future<HomeFeaturedResponseModelDto> getHomeFeaturedProducts() {
    return _apiServices.getHomeFeaturedProducts();
  }

  @override
  Future<HomeSpecialOffersResponseModelDto> getHomeSpecialOffers({int? take}) {
    return _apiServices.getHomeSpecialOffers(take);
  }

  @override
  Future<List<HomeExploreMoreResponseModelDto>> getHomeExploreMore() {
    return _apiServices.getHomeExploreMore();
  }
}
