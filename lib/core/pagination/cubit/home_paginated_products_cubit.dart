import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/pagination/models/paginated_section_page_data.dart';
import 'package:zadana_user_v3/core/pagination/models/paginated_section_state.dart';
import 'package:zadana_user_v3/core/services/favorite_sync_service.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

abstract class HomePaginatedProductsCubit
    extends Cubit<PaginatedSectionState<ProductModel>> {
  HomePaginatedProductsCubit({required String initialTitle})
    : super(PaginatedSectionState<ProductModel>(title: initialTitle)) {
    _favoriteSyncService.addListener(_syncFavoriteState);
  }

  static const int pageSize = 12;

  final FavoriteSyncService _favoriteSyncService = FavoriteSyncService();
  int _currentTake = pageSize;

  Future<ApiResult<PaginatedSectionPageData<ProductModel>>> fetchSection(
    int take,
  );

  Future<void> loadInitial() => _load(reset: true);

  Future<void> refresh() => _load(reset: true);

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    _currentTake += pageSize;
    await _load(reset: false, isLoadMore: true, take: _currentTake);
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

    final result = await fetchSection(effectiveTake);

    switch (result) {
      case ApiSuccessResult<PaginatedSectionPageData<ProductModel>>():
        final data = result.data;
        final hasMore = data.totalCount > data.items.length;
        emit(
          state.copyWith(
            title: data.title,
            items: data.items,
            isLoading: false,
            isLoadingMore: false,
            hasMore: hasMore,
            clearFailure: true,
          ),
        );
      case ApiErrorResult<PaginatedSectionPageData<ProductModel>>():
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

  void _syncFavoriteState() {
    final productId = _favoriteSyncService.productId;
    final isFavorite = _favoriteSyncService.isFavorite;
    if (productId == null || isFavorite == null) return;

    emit(
      state.copyWith(
        items: state.items
            .map(
              (item) => item.id == productId
                  ? item.copyWith(isFavorite: isFavorite)
                  : item,
            )
            .toList(),
      ),
    );
  }

  @override
  Future<void> close() {
    _favoriteSyncService.removeListener(_syncFavoriteState);
    return super.close();
  }
}
