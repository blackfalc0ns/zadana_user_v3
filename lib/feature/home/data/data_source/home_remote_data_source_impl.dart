import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/home/data/data_source/home_remote_data_source.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_banner_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_best_selling_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/home_categories_response_model_dto.dart';
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
  Future<HomeBestSellingResponseModelDto> getHomeBestSelling() {
    return _apiServices.getHomeBestSelling();
  }
}
