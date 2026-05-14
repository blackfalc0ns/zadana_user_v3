import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_best_selling_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_explore_more_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_featured_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_recommended_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_special_offers_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/get_home_app_bar_usecase.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/get_home_banners_usecase.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/get_home_best_selling_usecase.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/get_home_brands_usecase.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/get_home_categories_usecase.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/get_home_dynamic_sections_usecase.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/get_home_featured_products_usecase.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/get_home_recommended_usecase.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/get_home_special_offers_usecase.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_event.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel(
    this._getHomeAppBarUseCase,
    this._getHomeBannersUseCase,
    this._getHomeCategoriesUseCase,
    this._getHomeBestSellingUseCase,
    this._getHomeBrandsUseCase,
    this._getHomeRecommendedUseCase,
    this._getHomeFeaturedProductsUseCase,
    this._getHomeSpecialOffersUseCase,
    this._getHomeDynamicSectionsUseCase,
  ) : super(const HomeState());
  static const int _homeSectionPreviewTake = 5;
  static const int _homeBrandsPreviewTake = 8;

  final GetHomeAppBarUseCase _getHomeAppBarUseCase;
  final GetHomeBannersUseCase _getHomeBannersUseCase;
  final GetHomeCategoriesUseCase _getHomeCategoriesUseCase;
  final GetHomeBestSellingUseCase _getHomeBestSellingUseCase;
  final GetHomeBrandsUseCase _getHomeBrandsUseCase;
  final GetHomeRecommendedUseCase _getHomeRecommendedUseCase;
  final GetHomeFeaturedProductsUseCase _getHomeFeaturedProductsUseCase;
  final GetHomeSpecialOffersUseCase _getHomeSpecialOffersUseCase;
  final GetHomeDynamicSectionsUseCase _getHomeDynamicSectionsUseCase;

  bool _isLoadingInitial = false;

  Future<void> loadInitial() async {
    if (_isLoadingInitial) return;
    _isLoadingInitial = true;
    unawaited(_getHomeAppBar());
    unawaited(_getHomeBanners());
    unawaited(_getHomeCategories());
    unawaited(_getHomeBestSelling());
    unawaited(_getHomeBrands());
    unawaited(_getHomeRecommended());
    unawaited(_getHomeFeatured());
    unawaited(_getHomeSpecialOffers());
    unawaited(_getHomeDynamicSections());
    // Allow re-entry after a short delay to prevent double-fire on init
    // but still allow manual refresh/retry.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _isLoadingInitial = false;
  }

  void doIntent(HomeEvent event) {
    switch (event) {
      case HomeLoadEvent():
        loadInitial();
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
      case HomeDynamicSectionLoadEvent():
        _getHomeDynamicSections();
      case HomeRetryEvent():
        loadInitial();
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
      case HomeDynamicSectionRetryEvent():
        _getHomeDynamicSections();
      case HomeAppBarLoadEvent():
        _getHomeAppBar();
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

    final result = await _getHomeAppBarUseCase();

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

    final result = await _getHomeBannersUseCase();

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

    final result = await _getHomeCategoriesUseCase();

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

    final result = await _getHomeBestSellingUseCase(
      take: _homeSectionPreviewTake,
    );

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

    final result = await _getHomeBrandsUseCase(take: _homeBrandsPreviewTake);

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

    final result = await _getHomeRecommendedUseCase(
      take: _homeSectionPreviewTake,
    );

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

    final result = await _getHomeFeaturedProductsUseCase();

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

    final result = await _getHomeSpecialOffersUseCase(
      take: _homeSectionPreviewTake,
    );

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

  Future<void> _getHomeDynamicSections() async {
    emit(
      state.copyWith(
        dynamicSection: state.dynamicSection.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    developer.log('Loading home dynamic sections', name: 'HomeViewModel');

    final result = await _getHomeDynamicSectionsUseCase();

    switch (result) {
      case ApiSuccessResult():
        developer.log('Home dynamic sections loaded', name: 'HomeViewModel');
        emit(
          state.copyWith(
            dynamicSection: state.dynamicSection.copyWith(
              isLoading: false,
              isSuccess: true,
              clearFailure: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        developer.log(
          'Home dynamic sections failed: ${result.failure.errorMessage}',
          name: 'HomeViewModel',
        );
        emit(
          state.copyWith(
            dynamicSection: state.dynamicSection.copyWith(
              isLoading: false,
              isSuccess: false,
              clearData: true,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  void syncFavorite({required String productId, required bool isFavorite}) {
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
        dynamicSection: state.dynamicSection.copyWith(
          data: _updateDynamicSectionFavorites(
            state.dynamicSection.data,
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

  List<HomeExploreMoreEntity>? _updateDynamicSectionFavorites(
    List<HomeExploreMoreEntity>? sections,
    String productId,
    bool isFavorite,
  ) {
    if (sections == null) return null;
    return sections
        .map(
          (section) => HomeExploreMoreEntity(
            key: section.key,
            title: section.title,
            isActive: section.isActive,
            theme: section.theme,
            itemsCount: section.itemsCount,
            items: _updateProductFavorites(
              section.items,
              productId,
              isFavorite,
            ),
          ),
        )
        .toList();
  }
}
