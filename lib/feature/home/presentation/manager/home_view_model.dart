import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/home_usecase.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_event.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  final HomeUseCase _homeUseCase;

  HomeViewModel(this._homeUseCase) : super(const HomeState());

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
      case HomeRetryEvent():
        _getHomeAppBar();
      case HomeBannerRetryEvent():
        _getHomeBanners();
      case HomeCategoriesRetryEvent():
        _getHomeCategories();
      case HomeBestSellingRetryEvent():
        _getHomeBestSelling();
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
}
