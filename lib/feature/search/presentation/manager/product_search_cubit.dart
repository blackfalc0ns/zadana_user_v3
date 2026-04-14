import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/favorite_sync_service.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_entity.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_params.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_request_entity.dart';
import 'package:zadana_user_v3/feature/search/domain/usecase/search_products_usecase.dart';
import 'package:zadana_user_v3/feature/search/presentation/manager/product_search_event.dart';
import 'package:zadana_user_v3/feature/search/presentation/manager/product_search_state.dart';

@injectable
class ProductSearchViewModel extends Cubit<ProductSearchState> {
  ProductSearchViewModel(
    this._searchProductsUseCase,
    @factoryParam this._params,
  ) : super(const ProductSearchState()) {
    _favoriteSyncService.addListener(_syncFavoriteState);
    _submitInitialQuery();
  }

  static const int pageSize = 20;
  static const Duration debounceDuration = Duration(milliseconds: 700);

  final SearchProductsUseCase _searchProductsUseCase;
  final ProductSearchParams _params;
  final FavoriteSyncService _favoriteSyncService = FavoriteSyncService();

  Timer? _debounce;
  int _page = 1;
  int _requestSequence = 0;

  void _submitInitialQuery() {
    final initialQuery = _params.initialQuery.trim();
    if (initialQuery.isEmpty) return;
    Future.microtask(() => doIntent(ProductSearchSubmitEvent(initialQuery)));
  }

  void doIntent(ProductSearchEvent event) {
    switch (event) {
      case ProductSearchQueryChangedEvent():
        _onQueryChanged(event);
      case ProductSearchSubmitEvent():
        _search(event.query, reset: true);
      case ProductSearchLoadMoreEvent():
        _loadMore();
      case ProductSearchRefreshEvent():
        _refresh();
      case ProductSearchRetryEvent():
        _retry();
    }
  }

  void _onQueryChanged(ProductSearchQueryChangedEvent event) {
    final query = event.query.trim();
    if (query == state.query.trim()) return;

    _debounce?.cancel();
    _requestSequence += 1;

    emit(
      state.copyWith(
        query: event.query,
        clearFailure: true,
      ),
    );

    if (query.isEmpty) {
      _page = 1;
      emit(
        state.copyWith(
          items: const [],
          isLoading: false,
          isLoadingMore: false,
          hasMore: false,
          totalCount: 0,
          clearFailure: true,
        ),
      );
      return;
    }

    _debounce = Timer(debounceDuration, () {
      doIntent(ProductSearchSubmitEvent(query));
    });
  }

  Future<void> _search(String rawQuery, {required bool reset}) async {
    final query = rawQuery.trim();
    if (query.isEmpty) return;

    final requestId = ++_requestSequence;
    if (reset) {
      _page = 1;
      emit(
        state.copyWith(
          query: rawQuery,
          isLoading: true,
          isLoadingMore: false,
          hasMore: true,
          clearFailure: true,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMore: true, clearFailure: true));
    }

    final result = await _searchProductsUseCase.call(
      ProductSearchRequestEntity(
        query: query,
        categoryId: _params.categoryId,
        brandId: _params.brandId,
        minPrice: _params.minPrice,
        maxPrice: _params.maxPrice,
        sort: _params.sort,
        page: _page,
      ),
    );

    if (isClosed || requestId != _requestSequence) return;

    switch (result) {
      case ApiSuccessResult<ProductSearchEntity>():
        final mergedItems = reset
            ? result.data.items
            : [...state.items, ...result.data.items];
        emit(
          state.copyWith(
            query: rawQuery,
            items: mergedItems,
            isLoading: false,
            isLoadingMore: false,
            totalCount: result.data.total,
            hasMore: mergedItems.length < result.data.total,
            clearFailure: true,
          ),
        );
      case ApiErrorResult<ProductSearchEntity>():
        if (!reset) {
          _page = _page > 1 ? _page - 1 : 1;
        }
        emit(
          state.copyWith(
            query: rawQuery,
            isLoading: false,
            isLoadingMore: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _loadMore() async {
    if (!state.hasQuery ||
        state.isLoading ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    _page += 1;
    await _search(state.query, reset: false);
  }

  Future<void> _refresh() async {
    if (!state.hasQuery) return;
    await _search(state.query, reset: true);
  }

  Future<void> _retry() async {
    if (!state.hasQuery) return;
    await _search(state.query, reset: state.items.isEmpty);
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
    _debounce?.cancel();
    _favoriteSyncService.removeListener(_syncFavoriteState);
    return super.close();
  }
}
