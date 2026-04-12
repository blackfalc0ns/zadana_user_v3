import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/favorite_sync_service.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_best_selling_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_explore_more_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_featured_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_recommended_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_special_offers_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/home_usecase.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_event.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  final HomeUseCase _homeUseCase;
  final FavoriteSyncService _favoriteSyncService = FavoriteSyncService();

  HomeViewModel(this._homeUseCase) : super(const HomeState()) {
    _favoriteSyncService.addListener(_syncFavoriteState);
  }

  void doIntent(HomeEvent event) {
    switch (event) {
      case HomeLoadEvent():
        _getHomeAppBar();
      case HomeBannerLoadEvent():
        _getHomeBanners();
      case HomeCategoriesLoadEvent():
        _getHomeCategories();
      case HomeBestSellingLoadEvent():
        _getHomeBestSelling();
      case HomeBrandsLoadEvent():
        _getHomeBrands();
      case HomeRecommendedLoadEvent():
        _getHomeRecommended();
      case HomeFeaturedLoadEvent():
        _getHomeFeatured();
      case HomeSpecialOffersLoadEvent():
        _getHomeSpecialOffers();
      case HomeExploreMoreLoadEvent():
        _getHomeExploreMore();
      case HomeRetryEvent():
        _getHomeAppBar();
      case HomeBannerRetryEvent():
        _getHomeBanners();
      case HomeCategoriesRetryEvent():
        _getHomeCategories();
      case HomeBestSellingRetryEvent():
        _getHomeBestSelling();
      case HomeBrandsRetryEvent():
        _getHomeBrands();
      case HomeRecommendedRetryEvent():
        _getHomeRecommended();
      case HomeFeaturedRetryEvent():
        _getHomeFeatured();
      case HomeSpecialOffersRetryEvent():
        _getHomeSpecialOffers();
      case HomeExploreMoreRetryEvent():
        _getHomeExploreMore();
      case HomeResetEvent():
        emit(const HomeState());
    }
  }

  Future<void> _getHomeAppBar() async {
    emit(
      state.copyWith(
        appBarSection: state.appBarSection.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    developer.log('Loading home top section', name: 'HomeViewModel');

    final result = await _homeUseCase.getHomeAppBar();

    switch (result) {
      case ApiSuccessResult():
        developer.log('Home top section loaded', name: 'HomeViewModel');
        emit(
          state.copyWith(
            appBarSection: state.appBarSection.copyWith(
              isLoading: false,
              isSuccess: true,
              clearFailure: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Home top section failed: ${result.failure.errorMessage}',
          name: 'HomeViewModel',
        );
        emit(
          state.copyWith(
            appBarSection: state.appBarSection.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getHomeBanners() async {
    emit(
      state.copyWith(
        bannerSection: state.bannerSection.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    developer.log('Loading home banners section', name: 'HomeViewModel');

    final result = await _homeUseCase.getHomeBanners();

    switch (result) {
      case ApiSuccessResult():
        developer.log('Home banners loaded', name: 'HomeViewModel');
        emit(
          state.copyWith(
            bannerSection: state.bannerSection.copyWith(
              isLoading: false,
              isSuccess: true,
              clearFailure: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Home banners failed: ${result.failure.errorMessage}',
          name: 'HomeViewModel',
        );
        emit(
          state.copyWith(
            bannerSection: state.bannerSection.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getHomeCategories() async {
    emit(
      state.copyWith(
        categoriesSection: state.categoriesSection.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    developer.log('Loading home categories section', name: 'HomeViewModel');

    final result = await _homeUseCase.getHomeCategories();

    switch (result) {
      case ApiSuccessResult():
        developer.log('Home categories loaded', name: 'HomeViewModel');
        emit(
          state.copyWith(
            categoriesSection: state.categoriesSection.copyWith(
              isLoading: false,
              isSuccess: true,
              clearFailure: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Home categories failed: ${result.failure.errorMessage}',
          name: 'HomeViewModel',
        );
        emit(
          state.copyWith(
            categoriesSection: state.categoriesSection.copyWith(
              isLoading: false,
              isSuccess: false,
              clearData: true,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getHomeBestSelling() async {
    emit(
      state.copyWith(
        bestSellingSection: state.bestSellingSection.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    developer.log('Loading home best selling section', name: 'HomeViewModel');

    final result = await _homeUseCase.getHomeBestSelling();

    switch (result) {
      case ApiSuccessResult():
        developer.log('Home best selling loaded', name: 'HomeViewModel');
        emit(
          state.copyWith(
            bestSellingSection: state.bestSellingSection.copyWith(
              isLoading: false,
              isSuccess: true,
              clearFailure: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Home best selling failed: ${result.failure.errorMessage}',
          name: 'HomeViewModel',
        );
        emit(
          state.copyWith(
            bestSellingSection: state.bestSellingSection.copyWith(
              isLoading: false,
              isSuccess: false,
              clearData: true,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getHomeBrands() async {
    emit(
      state.copyWith(
        brandsSection: state.brandsSection.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    developer.log('Loading home brands section', name: 'HomeViewModel');

    final result = await _homeUseCase.getHomeBrands();

    switch (result) {
      case ApiSuccessResult():
        developer.log('Home brands loaded', name: 'HomeViewModel');
        emit(
          state.copyWith(
            brandsSection: state.brandsSection.copyWith(
              isLoading: false,
              isSuccess: true,
              clearFailure: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Home brands failed: ${result.failure.errorMessage}',
          name: 'HomeViewModel',
        );
        emit(
          state.copyWith(
            brandsSection: state.brandsSection.copyWith(
              isLoading: false,
              isSuccess: false,
              clearData: true,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getHomeRecommended() async {
    emit(
      state.copyWith(
        recommendedSection: state.recommendedSection.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    developer.log('Loading home recommended section', name: 'HomeViewModel');

    final result = await _homeUseCase.getHomeRecommended();

    switch (result) {
      case ApiSuccessResult():
        developer.log('Home recommended loaded', name: 'HomeViewModel');
        emit(
          state.copyWith(
            recommendedSection: state.recommendedSection.copyWith(
              isLoading: false,
              isSuccess: true,
              clearFailure: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Home recommended failed: ${result.failure.errorMessage}',
          name: 'HomeViewModel',
        );
        emit(
          state.copyWith(
            recommendedSection: state.recommendedSection.copyWith(
              isLoading: false,
              isSuccess: false,
              clearData: true,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getHomeFeatured() async {
    emit(
      state.copyWith(
        featuredSection: state.featuredSection.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    developer.log('Loading home featured section', name: 'HomeViewModel');

    final result = await _homeUseCase.getHomeFeaturedProducts();

    switch (result) {
      case ApiSuccessResult():
        developer.log('Home featured loaded', name: 'HomeViewModel');
        emit(
          state.copyWith(
            featuredSection: state.featuredSection.copyWith(
              isLoading: false,
              isSuccess: true,
              clearFailure: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Home featured failed: ${result.failure.errorMessage}',
          name: 'HomeViewModel',
        );
        emit(
          state.copyWith(
            featuredSection: state.featuredSection.copyWith(
              isLoading: false,
              isSuccess: false,
              clearData: true,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getHomeSpecialOffers() async {
    emit(
      state.copyWith(
        specialOffersSection: state.specialOffersSection.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    developer.log('Loading home special offers section', name: 'HomeViewModel');

    final result = await _homeUseCase.getHomeSpecialOffers();

    switch (result) {
      case ApiSuccessResult():
        developer.log('Home special offers loaded', name: 'HomeViewModel');
        emit(
          state.copyWith(
            specialOffersSection: state.specialOffersSection.copyWith(
              isLoading: false,
              isSuccess: true,
              clearFailure: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Home special offers failed: ${result.failure.errorMessage}',
          name: 'HomeViewModel',
        );
        emit(
          state.copyWith(
            specialOffersSection: state.specialOffersSection.copyWith(
              isLoading: false,
              isSuccess: false,
              clearData: true,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getHomeExploreMore() async {
    emit(
      state.copyWith(
        exploreMoreSection: state.exploreMoreSection.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    developer.log('Loading home explore more section', name: 'HomeViewModel');

    final result = await _homeUseCase.getHomeExploreMore();

    switch (result) {
      case ApiSuccessResult():
        developer.log('Home explore more loaded', name: 'HomeViewModel');
        emit(
          state.copyWith(
            exploreMoreSection: state.exploreMoreSection.copyWith(
              isLoading: false,
              isSuccess: true,
              clearFailure: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Home explore more failed: ${result.failure.errorMessage}',
          name: 'HomeViewModel',
        );
        emit(
          state.copyWith(
            exploreMoreSection: state.exploreMoreSection.copyWith(
              isLoading: false,
              isSuccess: false,
              clearData: true,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  void _syncFavoriteState() {
    final productId = _favoriteSyncService.productId;
    final isFavorite = _favoriteSyncService.isFavorite;

    if (productId == null || isFavorite == null) return;

    emit(
      state.copyWith(
        bestSellingSection: state.bestSellingSection.copyWith(
          data: _updateBestSellingFavorites(
            state.bestSellingSection.data,
            productId,
            isFavorite,
          ),
        ),
        recommendedSection: state.recommendedSection.copyWith(
          data: _updateRecommendedFavorites(
            state.recommendedSection.data,
            productId,
            isFavorite,
          ),
        ),
        featuredSection: state.featuredSection.copyWith(
          data: _updateFeaturedFavorites(
            state.featuredSection.data,
            productId,
            isFavorite,
          ),
        ),
        specialOffersSection: state.specialOffersSection.copyWith(
          data: _updateSpecialOffersFavorites(
            state.specialOffersSection.data,
            productId,
            isFavorite,
          ),
        ),
        exploreMoreSection: state.exploreMoreSection.copyWith(
          data: _updateExploreMoreFavorites(
            state.exploreMoreSection.data,
            productId,
            isFavorite,
          ),
        ),
      ),
    );
  }

  List<ProductModel> _updateProductFavorites(
    List<ProductModel> items,
    String productId,
    bool isFavorite,
  ) {
    return items
        .map(
          (item) => item.id == productId
              ? item.copyWith(isFavorite: isFavorite)
              : item,
        )
        .toList();
  }

  HomeBestSellingEntity? _updateBestSellingFavorites(
    HomeBestSellingEntity? section,
    String productId,
    bool isFavorite,
  ) {
    if (section == null) return null;
    return HomeBestSellingEntity(
      key: section.key,
      title: section.title,
      isActive: section.isActive,
      theme: section.theme,
      itemsCount: section.itemsCount,
      items: _updateProductFavorites(section.items, productId, isFavorite),
    );
  }

  HomeRecommendedEntity? _updateRecommendedFavorites(
    HomeRecommendedEntity? section,
    String productId,
    bool isFavorite,
  ) {
    if (section == null) return null;
    return HomeRecommendedEntity(
      key: section.key,
      title: section.title,
      isActive: section.isActive,
      theme: section.theme,
      itemsCount: section.itemsCount,
      items: _updateProductFavorites(section.items, productId, isFavorite),
    );
  }

  HomeFeaturedEntity? _updateFeaturedFavorites(
    HomeFeaturedEntity? section,
    String productId,
    bool isFavorite,
  ) {
    if (section == null) return null;
    return HomeFeaturedEntity(
      key: section.key,
      title: section.title,
      isActive: section.isActive,
      theme: section.theme,
      itemsCount: section.itemsCount,
      items: _updateProductFavorites(section.items, productId, isFavorite),
    );
  }

  HomeSpecialOffersEntity? _updateSpecialOffersFavorites(
    HomeSpecialOffersEntity? section,
    String productId,
    bool isFavorite,
  ) {
    if (section == null) return null;
    return HomeSpecialOffersEntity(
      key: section.key,
      title: section.title,
      isActive: section.isActive,
      theme: section.theme,
      itemsCount: section.itemsCount,
      items: _updateProductFavorites(section.items, productId, isFavorite),
    );
  }

  HomeExploreMoreEntity? _updateExploreMoreFavorites(
    HomeExploreMoreEntity? section,
    String productId,
    bool isFavorite,
  ) {
    if (section == null) return null;
    return HomeExploreMoreEntity(
      key: section.key,
      title: section.title,
      isActive: section.isActive,
      theme: section.theme,
      itemsCount: section.itemsCount,
      items: _updateProductFavorites(section.items, productId, isFavorite),
    );
  }

  @override
  Future<void> close() {
    _favoriteSyncService.removeListener(_syncFavoriteState);
    return super.close();
  }
}
