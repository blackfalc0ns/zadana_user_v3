import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/home/data/data_source/home_remote_data_source.dart';
import 'package:zadana_user_v3/feature/home/data/mapper/home_mapper.dart';
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

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  const HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<HomeAppBarEntity>> getHomeAppBar() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getHomeAppBar();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<HomeBannerEntity>> getHomeBanners() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getHomeBanners();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<HomeCategoriesEntity>> getHomeCategories() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getHomeCategories();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<HomeBestSellingEntity>> getHomeBestSelling() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getHomeBestSelling();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<HomeBrandsEntity>> getHomeBrands() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getHomeBrands();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<HomeRecommendedEntity>> getHomeRecommended() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getHomeRecommended();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<HomeFeaturedEntity>> getHomeFeaturedProducts() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getHomeFeaturedProducts();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<HomeSpecialOffersEntity>> getHomeSpecialOffers() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getHomeSpecialOffers();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<HomeExploreMoreEntity>> getHomeExploreMore() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getHomeExploreMore();
      return response.toEntity();
    });
  }
}
