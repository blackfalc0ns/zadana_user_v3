import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_banner_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_best_selling_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_brands_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_categories_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_explore_more_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_featured_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_recommended_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_special_offers_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_response_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/repo/home_repository.dart';

@injectable
class HomeUseCase {
  final HomeRepository _repository;

  const HomeUseCase(this._repository);

  Future<ApiResult<HomeAppBarEntity>> getHomeAppBar() async {
    return _repository.getHomeAppBar();
  }

  Future<ApiResult<HomeBannerEntity>> getHomeBanners() async {
    return _repository.getHomeBanners();
  }

  Future<ApiResult<HomeCategoriesEntity>> getHomeCategories() async {
    return _repository.getHomeCategories();
  }

  Future<ApiResult<HomeBestSellingEntity>> getHomeBestSelling() async {
    return _repository.getHomeBestSelling();
  }

  Future<ApiResult<HomeBrandsEntity>> getHomeBrands() async {
    return _repository.getHomeBrands();
  }

  Future<ApiResult<HomeRecommendedEntity>> getHomeRecommended() async {
    return _repository.getHomeRecommended();
  }

  Future<ApiResult<HomeFeaturedEntity>> getHomeFeaturedProducts() async {
    return _repository.getHomeFeaturedProducts();
  }

  Future<ApiResult<HomeSpecialOffersEntity>> getHomeSpecialOffers() async {
    return _repository.getHomeSpecialOffers();
  }

  Future<ApiResult<HomeExploreMoreEntity>> getHomeExploreMore() async {
    return _repository.getHomeExploreMore();
  }
}
