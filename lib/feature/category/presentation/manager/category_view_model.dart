import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/core/services/favorite_sync_service.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_products_request_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/shopping_products_request_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_categories_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_category_filters_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_category_products_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_category_subcategories_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_shopping_products_usecase.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_event.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_state.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_state_extensions.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_view_model_support.dart';

@injectable
class CategoryViewModel extends Cubit<CategoryState> {
  CategoryViewModel({
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetCategoryFiltersUseCase getCategoryFiltersUseCase,
    required GetCategorySubcategoriesUseCase getCategorySubcategoriesUseCase,
    required GetCategoryProductsUseCase getCategoryProductsUseCase,
    required GetShoppingProductsUseCase getShoppingProductsUseCase,
    required CategoryNavigationService navigationService,
    required FavoriteSyncService favoriteSyncService,
  }) : _getCategoriesUseCase = getCategoriesUseCase,
       _getCategoryFiltersUseCase = getCategoryFiltersUseCase,
       _getCategorySubcategoriesUseCase = getCategorySubcategoriesUseCase,
       _getCategoryProductsUseCase = getCategoryProductsUseCase,
       _getShoppingProductsUseCase = getShoppingProductsUseCase,
       _navigationService = navigationService,
       _favoriteSyncService = favoriteSyncService,
       super(const CategoryState());

  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetCategoryFiltersUseCase _getCategoryFiltersUseCase;
  final GetCategorySubcategoriesUseCase _getCategorySubcategoriesUseCase;
  final GetCategoryProductsUseCase _getCategoryProductsUseCase;
  final GetShoppingProductsUseCase _getShoppingProductsUseCase;
  final CategoryNavigationService _navigationService;
  final FavoriteSyncService _favoriteSyncService;

  void doIntent(CategoryEvent event) {
    switch (event) {
      case CategoryInitializeEvent():
        loadInitialData();
      case CategorySelectCategoryByNameEvent():
        selectCategoryByName(event.categoryName);
      case CategorySelectSubCategoryEvent():
        selectSubCategory(event.subCategory);
      case CategoryApplySortEvent():
        applySort(event.sortValue);
      case CategoryApplyFiltersEvent():
        applyFilters(event.filters);
      case CategoryClearAllFiltersEvent():
        clearAllFilters();
      case CategoryRetryEvent():
        retry();
      case CategorySearchQueryChangedEvent():
        _handleSearchQueryChanged(event.query);
      case CategoryCloseSearchUiEvent():
        _closeSearchUi();
      case CategorySyncSearchPresentationEvent():
        _syncSearchPresentation(event);
      case CategoryRefreshSearchSessionEvent():
        _refreshSearchSession();
      case CategorySetActiveHeroProductEvent():
        _setActiveHeroProduct(event.productId);
    }
  }

  void initialize() {
    _favoriteSyncService.addListener(_syncFavoriteState);
    _navigationService.addListener(_checkSelectedCategory);
    doIntent(const CategoryInitializeEvent());
  }

  void _handleSearchQueryChanged(String query) {
    emit(state.withSearchQuery(query));
  }

  void _closeSearchUi() {
    emit(state.closeSearchUi());
  }

  void _syncSearchPresentation(CategorySyncSearchPresentationEvent event) {
    final hasQuery = event.query.trim().isNotEmpty;
    emit(
      state.syncSearchPresentation(
        hasQuery: hasQuery,
        isLoading: event.isLoading,
        hasItems: event.hasItems,
        hasFailure: event.hasFailure,
      ),
    );
  }

  void _refreshSearchSession() {
    emit(state.copyWith(searchSessionVersion: state.searchSessionVersion + 1));
  }

  void _setActiveHeroProduct(String? productId) {
    emit(state.copyWith(activeHeroProductId: productId));
  }

  Future<void> loadInitialData() async {
    emit(state.startInitialLoad());

    final result = await _getCategoriesUseCase();

    switch (result) {
      case ApiSuccessResult<List<CategoryEntity>>():
        final categories = result.data;
        emit(state.copyWith(categories: categories));

        final selectedFromHome = _navigationService.selectedCategory;
        final selectedSubCategoryId = _navigationService.selectedSubCategoryId;
        final selectedSubCategoryName =
            _navigationService.selectedSubCategoryName;
        final hasRequestedSubCategory =
            CategoryViewModelSupport.hasRequestedSubCategory(
              subCategoryId: selectedSubCategoryId,
              subCategoryName: selectedSubCategoryName,
            );
        final initialCategory =
            CategoryViewModelSupport.resolveRequestedCategory(
              state.categories,
              selectedFromHome,
            );

        if (selectedFromHome == null && !hasRequestedSubCategory) {
          await _loadDefaultShoppingView(categories: categories);
          return;
        }

        if (selectedFromHome == null) {
          await _loadDefaultShoppingView(categories: categories);
          await _applyExternalSubCategorySelection(
            subCategoryId: selectedSubCategoryId,
            subCategoryName: selectedSubCategoryName,
          );
          _navigationService.clearSelectedCategory();
          return;
        }

        if (initialCategory == null) {
          emit(state.missingRequestedCategory());
          return;
        }

        await selectCategory(initialCategory, fromOutside: true);
        _navigationService.clearSelectedCategory();
      case ApiErrorResult<List<CategoryEntity>>():
        emit(state.initialLoadFailed(result.failure));
    }
  }

  Future<void> selectCategory(
    CategoryEntity category, {
    bool fromOutside = false,
    bool showAllSubCategories = false,
  }) async {
    emit(
      state.selectingCategory(
        category: category,
        fromOutside: fromOutside,
        showAllSubCategories: showAllSubCategories,
      ),
    );

    if (showAllSubCategories) {
      final filtersResult = await _getFiltersForCategories(state.categories);

      switch (filtersResult) {
        case ApiSuccessResult<List<CategoryFiltersResponseModelDto>>():
          final categoryFilters = filtersResult.data;
          final selectedFilters = categoryFilters.firstWhere(
            (filters) => filters.category?.id == category.id,
            orElse: () => categoryFilters.first,
          );
          final shoppingSubCategories =
              CategoryViewModelSupport.buildShoppingSubCategories(
                categories: state.categories,
                categoryFilters: categoryFilters,
              );
          _applyCategoryFilters(
            selectedFilters,
            subCategories: shoppingSubCategories.subCategories,
            subCategoryCategoryMap: shoppingSubCategories.categoryMap,
          );
          await loadCategoryProducts();
        case ApiErrorResult<List<CategoryFiltersResponseModelDto>>(
          failure: final failure,
        ):
          _emitFiltersAndProductsFailure(failure);
      }
      return;
    }

    final filtersResult = await _getCategoryFiltersUseCase(category.id);
    final subCategoriesResult = await _getCategorySubcategoriesUseCase(
      category.id,
    );

    late final CategoryFiltersResponseModelDto filters;
    switch (filtersResult) {
      case ApiErrorResult<CategoryFiltersResponseModelDto>(
        failure: final failure,
      ):
        _emitFiltersAndProductsFailure(failure);
        return;
      case ApiSuccessResult<CategoryFiltersResponseModelDto>(data: final data):
        filters = data;
    }

    late final List<CategorySubcategoryItemDto> subCategories;
    switch (subCategoriesResult) {
      case ApiErrorResult<List<CategorySubcategoryItemDto>>(
        failure: final failure,
      ):
        _emitFiltersAndProductsFailure(failure);
        return;
      case ApiSuccessResult<List<CategorySubcategoryItemDto>>(data: final data):
        subCategories = data;
    }

    _applyCategoryFilters(
      filters,
      subCategories: subCategories,
      subCategoryCategoryMap: {
        for (final item in subCategories)
          if ((item.id ?? '').isNotEmpty) item.id!: category.id,
      },
    );
    await loadCategoryProducts();
  }

  Future<void> loadCategoryProducts({
    String? overrideSubCategoryId,
    String? overrideCategoryId,
  }) async {
    final effectiveSubCategoryId =
        overrideSubCategoryId ?? state.selectedSubCategoryId;
    final isShoppingMode =
        state.showAllSubCategories && !state.isCategoryPreselectedFromOutside;

    if (isShoppingMode) {
      await _loadShoppingProducts(subcategoryId: effectiveSubCategoryId);
      return;
    }

    if (effectiveSubCategoryId == null || effectiveSubCategoryId.isEmpty) {
      final requestCategoryId =
          overrideCategoryId ??
          CategoryViewModelSupport.resolveCategoryIdForSubCategory(
            showAllSubCategories: state.showAllSubCategories,
            subCategoryCategoryMap: state.subCategoryCategoryMap,
            selectedCategoryId: state.selectedCategoryId,
            subCategoryId: effectiveSubCategoryId,
          ) ??
          state.selectedCategoryId;
      if (requestCategoryId == null || requestCategoryId.isEmpty) return;
      await _loadShoppingProducts();
      return;
    }

    emit(state.startProductsLoad());

    final result = await _getCategoryProductsUseCase(
      CategoryProductsRequestEntity(
        subCategoryId: effectiveSubCategoryId,
        productTypeId: state.selectedProductTypeId,
        partId: state.selectedPartId,
        quantityId: state.selectedQuantityId,
        brandId: state.selectedBrandId,
        minPrice: state.priceRange.start,
        maxPrice: state.priceRange.end,
        sort: state.selectedSortOption.isEmpty
            ? null
            : state.selectedSortOption,
      ),
    );

    switch (result) {
      case ApiSuccessResult():
        emit(state.productsLoaded(result.data));
      case ApiErrorResult():
        emit(state.productsLoadFailed(result.failure));
    }
  }

  void selectCategoryByName(String categoryName) {
    if (categoryName == state.selectedCategory) return;

    final category = CategoryViewModelSupport.findCategoryByName(
      state.categories,
      categoryName,
    );
    if (category == null) return;

    unawaited(selectCategory(category));
  }

  void selectSubCategory(CategorySubcategoryItemDto? subCategory) {
    final subCategoryId = subCategory?.id;
    final subCategoryName = subCategory?.name;
    final isSameSubCategory = state.selectedSubCategoryId == subCategoryId;
    final nextSubCategoryId = isSameSubCategory ? null : subCategoryId;
    final nextSubCategoryName = isSameSubCategory ? null : subCategoryName;

    if (state.showAllSubCategories && nextSubCategoryId != null) {
      unawaited(
        _selectShoppingSubCategory(
          subCategoryId: nextSubCategoryId,
          subCategoryName: nextSubCategoryName,
        ),
      );
      return;
    }

    emit(
      state.selectSubCategory(
        subCategoryId: nextSubCategoryId,
        subCategoryName: nextSubCategoryName,
      ),
    );

    unawaited(loadCategoryProducts(overrideSubCategoryId: nextSubCategoryId));
  }

  void applySort(String? sortValue) {
    emit(state.copyWith(selectedSortOption: sortValue ?? ''));
    unawaited(loadCategoryProducts());
  }

  void applyFilters(Map<String, dynamic>? result) {
    if (result == null) return;

    final categoryName = result['category'] as String?;
    final subCategoryId = result['subCategoryId'] as String?;
    final subCategoryName = result['subCategoryName'] as String?;
    if (categoryName != null && categoryName != state.selectedCategory) {
      unawaited(
        _applyCategoryChangeFromFilters(
          categoryName: categoryName,
          subCategoryId: subCategoryId,
          subCategoryName: subCategoryName,
        ),
      );
      return;
    }

    final quantity = result['quantity'] as String?;
    final brand = result['brand'] as String?;
    final productType = result['productType'] as String?;
    final part = result['part'] as String?;
    final priceRange =
        result['priceRange'] as RangeValues? ?? state.priceBounds;

    emit(
      state.applyFilterSelection(
        categoryName: categoryName,
        subCategoryId: subCategoryId,
        subCategoryName: subCategoryName,
        quantity: quantity,
        brand: brand,
        productType: productType,
        part: part,
        priceRange: priceRange,
      ),
    );

    unawaited(loadCategoryProducts());
  }

  Future<void> _applyCategoryChangeFromFilters({
    required String categoryName,
    String? subCategoryId,
    String? subCategoryName,
  }) async {
    final category = CategoryViewModelSupport.findCategoryByName(
      state.categories,
      categoryName,
    );
    if (category == null) return;

    await selectCategory(category);

    if (subCategoryId == null || subCategoryId.isEmpty) {
      return;
    }

    emit(
      state.selectSubCategory(
        subCategoryId: subCategoryId,
        subCategoryName: subCategoryName,
      ),
    );
    await loadCategoryProducts(overrideSubCategoryId: subCategoryId);
  }

  void clearAllFilters() {
    if (state.showAllSubCategories && !state.isCategoryPreselectedFromOutside) {
      unawaited(_loadDefaultShoppingView(categories: state.categories));
      return;
    }

    emit(state.clearFilters());
    unawaited(loadCategoryProducts());
  }

  void retry() {
    switch (state.retryAction) {
      case CategoryRetryAction.initialLoad:
        unawaited(loadInitialData());
      case CategoryRetryAction.loadFiltersAndProducts:
        final categoryId = state.selectedCategoryId;
        if (categoryId == null || categoryId.isEmpty) {
          unawaited(loadInitialData());
          return;
        }
        final category = state.categories.firstWhere(
          (item) => item.id == categoryId,
          orElse: () => CategoryViewModelSupport.buildFallbackCategory(
            id: categoryId,
            name: state.selectedCategory,
          ),
        );
        unawaited(
          selectCategory(
            category,
            fromOutside: state.isCategoryPreselectedFromOutside,
            showAllSubCategories: state.showAllSubCategories,
          ),
        );
      case CategoryRetryAction.loadProducts:
        if (state.showAllSubCategories &&
            !state.isCategoryPreselectedFromOutside &&
            (state.selectedCategoryId == null ||
                state.selectedCategoryId!.isEmpty)) {
          unawaited(_loadDefaultShoppingView(categories: state.categories));
          return;
        }
        unawaited(loadCategoryProducts());
    }
  }

  void _applyCategoryFilters(
    CategoryFiltersResponseModelDto filters, {
    List<CategorySubcategoryItemDto>? subCategories,
    Map<String, String>? subCategoryCategoryMap,
  }) {
    final filtersState = CategoryViewModelSupport.resolveFiltersState(
      filters,
      subCategories: subCategories,
    );

    emit(
      state.applyCategoryFilters(
        filtersState,
        subCategoryCategoryMap: subCategoryCategoryMap,
      ),
    );
  }

  Future<void> _selectShoppingSubCategory({
    required String subCategoryId,
    required String? subCategoryName,
  }) async {
    final targetCategoryId =
        CategoryViewModelSupport.resolveCategoryIdForSubCategory(
          showAllSubCategories: state.showAllSubCategories,
          subCategoryCategoryMap: state.subCategoryCategoryMap,
          selectedCategoryId: state.selectedCategoryId,
          subCategoryId: subCategoryId,
        );
    if (targetCategoryId == null || targetCategoryId.isEmpty) {
      emit(
        state.selectSubCategory(
          subCategoryId: subCategoryId,
          subCategoryName: subCategoryName,
        ),
      );
      await loadCategoryProducts(overrideSubCategoryId: subCategoryId);
      return;
    }

    final category = state.categories.firstWhere(
      (item) => item.id == targetCategoryId,
      orElse: () => CategoryViewModelSupport.buildFallbackCategory(
        id: targetCategoryId,
        name: state.selectedCategory,
        emoji: '',
      ),
    );

    emit(
      state.selectShoppingSubCategory(
        category: category,
        subCategoryId: subCategoryId,
        subCategoryName: subCategoryName,
      ),
    );

    final filtersResult = await _getCategoryFiltersUseCase(targetCategoryId);

    switch (filtersResult) {
      case ApiSuccessResult<CategoryFiltersResponseModelDto>():
        _applyCategoryFilters(
          filtersResult.data,
          subCategories: state.subCategories,
          subCategoryCategoryMap: state.subCategoryCategoryMap,
        );
        emit(
          state.selectSubCategory(
            subCategoryId: subCategoryId,
            subCategoryName: subCategoryName,
          ),
        );
        await loadCategoryProducts(
          overrideSubCategoryId: subCategoryId,
          overrideCategoryId: targetCategoryId,
        );
      case ApiErrorResult<CategoryFiltersResponseModelDto>():
        emit(state.filtersReloadFailed(filtersResult.failure));
    }
  }

  Future<void> _loadDefaultShoppingView({
    required List<CategoryEntity> categories,
  }) async {
    emit(state.startDefaultShoppingView(categories));

    final filtersResult = await _getFiltersForCategories(categories);

    switch (filtersResult) {
      case ApiSuccessResult<List<CategoryFiltersResponseModelDto>>():
        final shoppingSubCategories =
            CategoryViewModelSupport.buildShoppingSubCategories(
              categories: categories,
              categoryFilters: filtersResult.data,
            );

        emit(state.loadedShoppingSubCategories(shoppingSubCategories));

        await _loadShoppingProducts();
      case ApiErrorResult<List<CategoryFiltersResponseModelDto>>():
        emit(state.defaultShoppingLoadFailed(filtersResult.failure));
    }
  }

  Future<void> _loadShoppingProducts({String? subcategoryId}) async {
    emit(state.startProductsLoad());

    final hasPriceFilter = state.priceRange != state.priceBounds;
    final result = await _getShoppingProductsUseCase(
      ShoppingProductsRequestEntity(
        categoryId: subcategoryId,
        productTypeId: state.selectedProductTypeId,
        partId: state.selectedPartId,
        quantityId: state.selectedQuantityId,
        brandId: state.selectedBrandId,
        minPrice: hasPriceFilter ? state.priceRange.start : null,
        maxPrice: hasPriceFilter ? state.priceRange.end : null,
        sort: state.selectedSortOption.isEmpty
            ? null
            : state.selectedSortOption,
      ),
    );

    switch (result) {
      case ApiSuccessResult():
        emit(state.productsLoaded(result.data));
      case ApiErrorResult():
        emit(state.productsLoadFailed(result.failure));
    }
  }

  void _checkSelectedCategory() {
    final requested = CategoryViewModelSupport.resolveRequestedCategory(
      state.categories,
      _navigationService.selectedCategory,
    );
    if (requested == null) {
      final selectedSubCategoryId = _navigationService.selectedSubCategoryId;
      final selectedSubCategoryName =
          _navigationService.selectedSubCategoryName;
      final hasRequestedSubCategory =
          CategoryViewModelSupport.hasRequestedSubCategory(
            subCategoryId: selectedSubCategoryId,
            subCategoryName: selectedSubCategoryName,
          );

      if (hasRequestedSubCategory) {
        if (state.categories.isEmpty) {
          unawaited(loadInitialData());
          return;
        }

        unawaited(
          _applyExternalSubCategorySelection(
            subCategoryId: selectedSubCategoryId,
            subCategoryName: selectedSubCategoryName,
          ),
        );
        _navigationService.clearSelectedCategory();
        return;
      }

      if (_navigationService.consumeResetToDefault()) {
        if (state.categories.isEmpty) {
          unawaited(loadInitialData());
          return;
        }
        unawaited(_loadDefaultShoppingView(categories: state.categories));
      }
      return;
    }

    unawaited(selectCategory(requested, fromOutside: true));
    _navigationService.clearSelectedCategory();
  }

  Future<void> _applyExternalSubCategorySelection({
    String? subCategoryId,
    String? subCategoryName,
  }) async {
    if (state.categories.isEmpty) {
      return;
    }

    if (!state.showAllSubCategories || state.isCategoryPreselectedFromOutside) {
      await _loadDefaultShoppingView(categories: state.categories);
    }

    final requestedSubCategory =
        CategoryViewModelSupport.resolveRequestedSubCategory(
          state.subCategories,
          subCategoryId: subCategoryId,
          subCategoryName: subCategoryName,
        );
    if (requestedSubCategory == null) {
      return;
    }

    final resolvedSubCategoryId = requestedSubCategory.id;
    if (resolvedSubCategoryId == null || resolvedSubCategoryId.isEmpty) {
      return;
    }

    await _selectShoppingSubCategory(
      subCategoryId: resolvedSubCategoryId,
      subCategoryName: requestedSubCategory.name,
    );
  }

  void _syncFavoriteState() {
    final productId = _favoriteSyncService.productId;
    final isFavorite = _favoriteSyncService.isFavorite;

    if (productId == null || isFavorite == null) return;

    emit(
      state.syncFavoriteState(productId: productId, isFavorite: isFavorite),
    );
  }

  Future<ApiResult<List<CategoryFiltersResponseModelDto>>>
  _getFiltersForCategories(List<CategoryEntity> categories) async {
    final results = await Future.wait(
      categories
          .map((item) => _getCategoryFiltersUseCase(item.id))
          .toList(growable: false),
    );

    final filters = <CategoryFiltersResponseModelDto>[];
    for (final result in results) {
      switch (result) {
        case ApiSuccessResult<CategoryFiltersResponseModelDto>():
          filters.add(result.data);
        case ApiErrorResult<CategoryFiltersResponseModelDto>():
          return ApiErrorResult<List<CategoryFiltersResponseModelDto>>(
            failure: result.failure,
          );
      }
    }

    return ApiSuccessResult<List<CategoryFiltersResponseModelDto>>(
      data: filters,
    );
  }

  void _emitFiltersAndProductsFailure(dynamic failure) {
    emit(state.filtersAndProductsFailed(failure));
  }

  @override
  Future<void> close() {
    _favoriteSyncService.removeListener(_syncFavoriteState);
    _navigationService.removeListener(_checkSelectedCategory);
    return super.close();
  }
}
