import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_banner_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_best_selling_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_categories_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_response_entity.dart';

abstract class HomeRepository {
  Future<ApiResult<HomeAppBarEntity>> getHomeAppBar();
  Future<ApiResult<HomeBannerEntity>> getHomeBanners();
  Future<ApiResult<HomeCategoriesEntity>> getHomeCategories();
  Future<ApiResult<HomeBestSellingEntity>> getHomeBestSelling();
}
