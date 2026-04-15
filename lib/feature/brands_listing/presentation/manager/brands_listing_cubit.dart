import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_brands_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/get_home_brands_usecase.dart';
import 'package:zadana_user_v3/feature/section_listing_shared/presentation/manager/paginated_section_page_data.dart';
import 'package:zadana_user_v3/feature/section_listing_shared/presentation/manager/paginated_section_state.dart';

@injectable
class BrandsListingCubit extends Cubit<PaginatedSectionState<BrandModel>> {
  BrandsListingCubit(
    this._getHomeBrandsUseCase,
    @factoryParam String title,
  ) : super(PaginatedSectionState<BrandModel>(title: title));

  static const int pageSize = 9;
  static const double loadMoreThreshold = 320;

  final GetHomeBrandsUseCase _getHomeBrandsUseCase;
  int _currentTake = pageSize;

  Future<void> loadInitial() => _load(reset: true);

  Future<void> refresh() => _load(reset: true);

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    _currentTake += pageSize;
    await _load(reset: false, isLoadMore: true, take: _currentTake);
  }

  Future<void> handleScrollExtent(double extentAfter) async {
    if (extentAfter > loadMoreThreshold) {
      return;
    }

    await loadMore();
  }

  Future<void> _load({
    required bool reset,
    bool isLoadMore = false,
    int? take,
  }) async {
    final effectiveTake = reset ? pageSize : (take ?? _currentTake);
    if (reset) {
      _currentTake = pageSize;
      emit(
        state.copyWith(
          isLoading: true,
          isLoadingMore: false,
          clearFailure: true,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMore: true, clearFailure: true));
    }

    final result = await _fetchBrands(effectiveTake);
    switch (result) {
      case ApiSuccessResult<PaginatedSectionPageData<BrandModel>>():
        final hasMore = result.data.items.length >= effectiveTake;
        emit(
          state.copyWith(
            items: result.data.items,
            isLoading: false,
            isLoadingMore: false,
            hasMore: hasMore,
            clearFailure: true,
          ),
        );
      case ApiErrorResult<PaginatedSectionPageData<BrandModel>>():
        if (isLoadMore) {
          _currentTake -= pageSize;
        }
        emit(
          state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<ApiResult<PaginatedSectionPageData<BrandModel>>> _fetchBrands(
    int take,
  ) async {
    final result = await _getHomeBrandsUseCase(take: take);
    switch (result) {
      case ApiSuccessResult<HomeBrandsEntity>():
        return ApiSuccessResult(
          data: PaginatedSectionPageData<BrandModel>(
            title: result.data.title,
            totalCount: result.data.itemsCount,
            items: result.data.items,
          ),
        );
      case ApiErrorResult<HomeBrandsEntity>():
        return ApiErrorResult(failure: result.failure);
    }
  }
}
