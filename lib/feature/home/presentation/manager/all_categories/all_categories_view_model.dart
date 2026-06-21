import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_categories_usecase.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/all_categories/all_categories_event.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/all_categories/all_categories_state.dart';

@injectable
class AllCategoriesViewModel extends Cubit<AllCategoriesState> {
  AllCategoriesViewModel(this._getCategoriesUseCase)
      : super(const AllCategoriesState());

  static const int _pageSize = 30;

  final GetCategoriesUseCase _getCategoriesUseCase;

  void doIntent(AllCategoriesEvent event) {
    switch (event) {
      case AllCategoriesLoadEvent():
        unawaited(_loadCategories());
      case AllCategoriesLoadMoreEvent():
        unawaited(_loadMore());
      case AllCategoriesRefreshEvent():
        unawaited(_refresh());
    }
  }

  Future<void> _loadCategories() async {
    emit(state.copyWith(isLoading: true, clearFailure: true));

    final result = await _getCategoriesUseCase(take: _pageSize);

    switch (result) {
      case ApiSuccessResult<List<CategoryEntity>>():
        emit(state.copyWith(
          categories: result.data,
          isLoading: false,
          hasMore: result.data.length >= _pageSize,
          clearFailure: true,
        ));
      case ApiErrorResult<List<CategoryEntity>>():
        emit(state.copyWith(
          isLoading: false,
          failure: result.failure,
        ));
    }
  }

  Future<void> _loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextTake = state.categories.length + _pageSize;
    final result = await _getCategoriesUseCase(take: nextTake);

    switch (result) {
      case ApiSuccessResult<List<CategoryEntity>>():
        final fetchedMore = result.data.length > state.categories.length;
        final reachedEnd = result.data.length < nextTake;
        emit(state.copyWith(
          categories: result.data,
          isLoadingMore: false,
          hasMore: fetchedMore && !reachedEnd,
        ));
      case ApiErrorResult<List<CategoryEntity>>():
        emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _refresh() async {
    emit(state.copyWith(hasMore: true, clearFailure: true));
    await _loadCategories();
  }
}
