import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/paginated_products_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_categories_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_category_filters_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_category_products_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_category_subcategories_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_shopping_products_usecase.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_event.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_filters_service.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_helpers.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_loader_service.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_navigation_handler.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_products_service.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_state.dart';

@injectable
class CategoryViewModel extends Cubit<CategoryState> {
  CategoryViewModel({
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetCategoryFiltersUseCase getCategoryFiltersUseCase,
    required GetCategorySubcategoriesUseCase getCategorySubcategoriesUseCase,
    required GetCategoryProductsUseCase getCategoryProductsUseCase,
    required GetShoppingProductsUseCase getShoppingProductsUseCase,
    required CategoryNavigationService navigationService,
  }) : _loaderService = CategoryLoaderService(
         getCategoriesUseCase: getCategoriesUseCase,
         getCategoryFiltersUseCase: getCategoryFiltersUseCase,
         getCategorySubcategoriesUseCase: getCategorySubcategoriesUseCase,
       ),
       _productsService = CategoryProductsService(
         getCategoryProductsUseCase: getCategoryProductsUseCase,
         getShoppingProductsUseCase: getShoppingProductsUseCase,
       ),
       _filtersService = const CategoryFiltersService(),
       _navigationHandler = CategoryNavigationHandler(navigationService),
       _navigationService = navigationService,
       super(const CategoryState());

  final CategoryLoaderService _loaderService;
  final CategoryProductsService _productsService;
  final CategoryFiltersService _filtersService;
  final CategoryNavigationHandler _navigationHandler;
  final CategoryNavigationService _navigationService;
  bool _isInitialized = false;

  void initialize({List<CategoryEntity>? preloadedCategories}) {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;
    _navigationService.addListener(_checkSelectedCategory);
    final validPreloadedCategories = (preloadedCategories ?? const [])
        .where((item) => item.id.isNotEmpty && item.name.isNotEmpty)
        .toList(growable: false);
    if (validPreloadedCategories.isNotEmpty) {
      unawaited(_handleInitialLoadSuccess(validPreloadedCategories));
      return;
    }

    doIntent(const CategoryInitializeEvent());
  }

  void doIntent(CategoryEvent event) {
    switch (event) {
      case CategoryInitializeEvent():
        unawaited(loadInitialData());
      case CategorySelectCategoryEvent():
        selectCategoryById(event.categoryId);
      case CategorySelectSubCategoryEvent():
        unawaited(selectSubCategory(event.subCategory));
      case CategoryApplySortEvent():
        _applySort(event.sortValue);
      case CategoryApplyFiltersEvent():
        unawaited(applyFilters(event.filters));
      case CategoryClearAllFiltersEvent():
        _clearAllFilters();
      case CategoryResetSelectionEvent():
        unawaited(_resetSelection());
      case CategoryRetryEvent():
        unawaited(retry());
      case CategorySetActiveHeroProductEvent():
        emit(state.copyWith(activeHeroProductId: event.productId));
      case CategoryLoadMoreProductsEvent():
        unawaited(_loadMoreProducts());
      case CategoryLoadMoreCategoriesEvent():
        unawaited(_loadMoreCategories());
      case CategoryLoadMoreSubCategoriesEvent():
        unawaited(_loadMoreSubCategories());
    }
  }

  Future<void> loadInitialData() async {
    emit(state.startInitialLoad());

    final result = await _loaderService.loadInitialCategories();
    switch (result) {
      case ApiSuccessResult<List<CategoryEntity>>():
        await _handleInitialLoadSuccess(result.data);
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

    final result = await _loaderService.loadCategorySelection(
      categories: state.categories,
      category: category,
      showAllSubCategories: showAllSubCategories,
    );

    switch (result) {
      case CategorySelectionLoadSuccess():
        _emitCategoryFilters(
          result.data.filters,
          subCategories: result.data.subCategories,
          subCategoryCategoryMap: result.data.subCategoryCategoryMap,
        );
        await loadCategoryProducts();
      case CategorySelectionLoadFailure():
        emit(state.filtersAndProductsFailed(result.failure));
    }
  }

  void selectCategoryById(String categoryId) {
    if (categoryId == state.selectedCategoryId) {
      return;
    }

    final category = findCategoryById(state.categories, categoryId);
    if (category == null) {
      return;
    }

    unawaited(selectCategory(category));
  }

  Future<void> selectSubCategory(
    CategorySubcategoryItemDto? subCategory,
  ) async {
    final nextSelection = _filtersService.resolveSubCategorySelection(
      state,
      subCategory,
    );

    if (state.showAllSubCategories && nextSelection.id != null) {
      await _selectShoppingSubCategory(
        subCategoryId: nextSelection.id!,
        subCategoryName: nextSelection.name,
        preferCategoryIdForShoppingSelection:
            state.preferCategoryIdForShoppingSelection,
      );
      return;
    }

    emit(
      state.selectSubCategory(
        subCategoryId: nextSelection.id,
        subCategoryName: nextSelection.name,
      ),
    );
    await loadCategoryProducts(overrideSubCategoryId: nextSelection.id);
  }

  Future<void> applyFilters(Map<String, dynamic>? result) async {
    if (result == null) {
      return;
    }

    final selection = _filtersService.fromMap(
      result,
      fallbackPriceRange: state.priceBounds,
    );

    if (_shouldChangeCategory(selection)) {
      await _applyCategoryChangeFromFilters(selection);
      return;
    }

    emit(
      state.applyFilterSelection(
        categoryName: selection.categoryName,
        subCategoryId: selection.subCategoryId,
        subCategoryName: selection.subCategoryName,
        quantity: selection.quantity,
        brand: selection.brand,
        productType: selection.productType,
        part: selection.part,
        packageType: selection.packageType,
        measurementUnit: selection.measurementUnit,
        measurementValue: selection.measurementValue,
        priceRange: selection.priceRange,
      ),
    );

    await loadCategoryProducts();
  }

  Future<void> retry() async {
    switch (state.retryAction) {
      case CategoryRetryAction.initialLoad:
        await loadInitialData();
      case CategoryRetryAction.loadFiltersAndProducts:
        await _retryFiltersAndProducts();
      case CategoryRetryAction.loadProducts:
        if (state.needsDefaultShoppingRetry) {
          await loadDefaultShoppingView(categories: state.categories);
          return;
        }
        await loadCategoryProducts();
    }
  }

  Future<void> loadCategoryProducts({
    String? overrideSubCategoryId,
    String? overrideCategoryId,
  }) async {
    emit(state.startProductsLoad());

    final result = await _productsService.loadProductsPaginated(
      state: state,
      page: 1,
      overrideSubCategoryId: overrideSubCategoryId,
      overrideCategoryId: overrideCategoryId,
    );

    _handlePaginatedProductsResult(result);
  }

  Future<void> _loadMoreProducts() async {
    if (state.isLoadingMore || !state.hasMoreProducts || state.isLoading) {
      return;
    }

    emit(state.startLoadingMore());

    final nextPage = state.currentPage + 1;
    final result = await _productsService.loadProductsPaginated(
      state: state,
      page: nextPage,
    );

    switch (result) {
      case ApiSuccessResult<PaginatedProductsEntity>():
        emit(
          state.moreProductsLoaded(
            appendedItems: result.data.items,
            page: result.data.page,
            total: result.data.total,
            hasMore: result.data.hasMore,
          ),
        );
      case ApiErrorResult<PaginatedProductsEntity>():
        // Silently fail on load more - don't show error
        emit(state.copyWith(isLoadingMore: false));
    }
  }

  static const int _categoriesPageSize = 8;

  Future<void> _loadMoreCategories() async {
    if (state.isLoadingMoreCategories || !state.hasMoreCategories) {
      return;
    }

    emit(state.copyWith(isLoadingMoreCategories: true));

    final nextTake = state.categories.length + _categoriesPageSize;
    final result = await _loaderService.loadInitialCategories(take: nextTake);

    switch (result) {
      case ApiSuccessResult<List<CategoryEntity>>():
        final newCategories = result.data;
        final hasMore = newCategories.length > state.categories.length;
        emit(state.copyWith(
          categories: newCategories,
          isLoadingMoreCategories: false,
          hasMoreCategories: hasMore,
        ));
      case ApiErrorResult<List<CategoryEntity>>():
        emit(state.copyWith(isLoadingMoreCategories: false));
    }
  }

  static const int _subCategoriesPageSize = 10;

  Future<void> _loadMoreSubCategories() async {
    if (state.isLoadingMoreSubCategories || !state.hasMoreSubCategories) {
      return;
    }

    emit(state.copyWith(isLoadingMoreSubCategories: true));

    final nextLimit = state.subCategories.length + _subCategoriesPageSize;
    final result = await _loaderService.loadSubCategories(limit: nextLimit);

    switch (result) {
      case ApiSuccessResult<List<CategorySubcategoryItemDto>>():
        final newItems = result.data;
        final hasMore = newItems.length > state.subCategories.length;
        final categoryMap = <String, String>{
          ...state.subCategoryCategoryMap,
        };
        emit(state.copyWith(
          subCategories: newItems,
          subCategoryCategoryMap: categoryMap,
          isLoadingMoreSubCategories: false,
          hasMoreSubCategories: hasMore,
        ));
      case ApiErrorResult<List<CategorySubcategoryItemDto>>():
        emit(state.copyWith(isLoadingMoreSubCategories: false));
    }
  }

  Future<void> loadDefaultShoppingView({
    required List<CategoryEntity> categories,
  }) async {
    emit(state.startDefaultShoppingView(categories));

    final result = await _loaderService.loadDefaultShoppingData();
    switch (result) {
      case DefaultShoppingLoadSuccess():
        emit(state.loadedShoppingSubCategories(result.data));
        await loadCategoryProducts();
      case DefaultShoppingLoadFailure():
        emit(state.defaultShoppingLoadFailed(result.failure));
    }
  }

  void syncFavorite({required String productId, required bool isFavorite}) {
    emit(state.syncFavoriteState(productId: productId, isFavorite: isFavorite));
  }

  void setActiveHeroProduct(String? productId) {
    doIntent(CategorySetActiveHeroProductEvent(productId));
  }

  void _applySort(String? sortValue) {
    emit(state.copyWith(selectedSortOption: sortValue ?? ''));
    unawaited(loadCategoryProducts());
  }

  void _clearAllFilters() {
    if (state.needsDefaultShoppingRetry) {
      unawaited(loadDefaultShoppingView(categories: state.categories));
      return;
    }

    emit(state.clearFilters());
    unawaited(loadCategoryProducts());
  }

  Future<void> _resetSelection() async {
    _navigationHandler.clearSelectedCategory();

    if (state.categories.isEmpty) {
      await loadInitialData();
      return;
    }

    await loadDefaultShoppingView(categories: state.categories);
  }

  Future<void> _checkSelectedCategory() async {
    final requestedCategory = _navigationHandler.resolveRequestedCategory(
      state.categories,
    );
    if (requestedCategory != null) {
      await selectCategory(requestedCategory, fromOutside: true);
      _navigationHandler.clearSelectedCategory();
      return;
    }

    // Category not in the loaded list — use it directly if available.
    final rawRequestedCategory = _navigationHandler.requestedCategory;
    if (rawRequestedCategory != null) {
      await selectCategory(rawRequestedCategory, fromOutside: true);
      _navigationHandler.clearSelectedCategory();
      return;
    }

    final requestedSubCategory = _navigationHandler
        .requestedSubCategorySelection();
    if (requestedSubCategory != null) {
      if (state.categories.isEmpty) {
        await loadInitialData();
        return;
      }

      await _applyExternalSubCategorySelection(
        subCategoryId: requestedSubCategory.subCategoryId,
        subCategoryName: requestedSubCategory.subCategoryName,
        preferCategoryId: requestedSubCategory.preferCategoryId,
      );
      _navigationHandler.clearSelectedCategory();
      return;
    }

    if (!_navigationHandler.consumeResetToDefault()) {
      return;
    }

    if (state.categories.isEmpty) {
      await loadInitialData();
      return;
    }

    await loadDefaultShoppingView(categories: state.categories);
  }

  Future<void> _handleInitialLoadSuccess(
    List<CategoryEntity> categories,
  ) async {
    emit(state.copyWith(categories: categories));

    final requestedSubCategory = _navigationHandler
        .requestedSubCategorySelection();
    final requestedCategory = _navigationHandler.resolveRequestedCategory(
      categories,
    );
    final rawRequestedCategory = _navigationHandler.requestedCategory;

    if (rawRequestedCategory == null) {
      await loadDefaultShoppingView(categories: categories);
      if (requestedSubCategory == null) {
        return;
      }

      await _applyExternalSubCategorySelection(
        subCategoryId: requestedSubCategory.subCategoryId,
        subCategoryName: requestedSubCategory.subCategoryName,
        preferCategoryId: requestedSubCategory.preferCategoryId,
      );
      _navigationHandler.clearSelectedCategory();
      return;
    }

    if (requestedCategory == null) {
      // Category not in the initially loaded list — use it directly.
      await selectCategory(rawRequestedCategory, fromOutside: true);
      _navigationHandler.clearSelectedCategory();
      return;
    }

    await selectCategory(requestedCategory, fromOutside: true);
    _navigationHandler.clearSelectedCategory();
  }

  Future<void> _applyCategoryChangeFromFilters(
    CategoryFilterSelection selection,
  ) async {
    final category =
        (selection.categoryId != null && selection.categoryId!.isNotEmpty)
        ? findCategoryById(state.categories, selection.categoryId!)
        : findCategoryByName(state.categories, selection.categoryName ?? '');
    if (category == null) {
      return;
    }

    await selectCategory(category);
    if (selection.subCategoryId == null || selection.subCategoryId!.isEmpty) {
      return;
    }

    emit(
      state.selectSubCategory(
        subCategoryId: selection.subCategoryId,
        subCategoryName: selection.subCategoryName,
      ),
    );
    await loadCategoryProducts(overrideSubCategoryId: selection.subCategoryId);
  }

  Future<void> _applyExternalSubCategorySelection({
    String? subCategoryId,
    String? subCategoryName,
    bool preferCategoryId = false,
  }) async {
    if (state.categories.isEmpty) {
      return;
    }

    if (!state.showAllSubCategories || state.isCategoryPreselectedFromOutside) {
      await loadDefaultShoppingView(categories: state.categories);
    }

    final requestedSubCategory = _navigationHandler.resolveRequestedSubCategory(
      state.subCategories,
      subCategoryId: subCategoryId,
      subCategoryName: subCategoryName,
    );
    final resolvedSubCategoryId = requestedSubCategory?.id;
    if (resolvedSubCategoryId != null && resolvedSubCategoryId.isNotEmpty) {
      await _selectShoppingSubCategory(
        subCategoryId: resolvedSubCategoryId,
        subCategoryName: requestedSubCategory?.name,
        preferCategoryIdForShoppingSelection: preferCategoryId,
      );
      return;
    }

    final result = await _loaderService.loadExternalSubCategorySelection(
      categories: state.categories,
      subCategoryId: subCategoryId,
      subCategoryName: subCategoryName,
    );
    switch (result) {
      case ExternalSubCategoryLoadSuccess():
        emit(
          state.selectShoppingSubCategory(
            category: result.category,
            subCategoryId: result.subCategory.id!,
            subCategoryName: result.subCategory.name,
            preferCategoryIdForShoppingSelection: preferCategoryId,
          ),
        );
        _emitCategoryFilters(
          result.data.filters,
          subCategories: result.data.subCategories,
          subCategoryCategoryMap: result.data.subCategoryCategoryMap,
        );
        emit(
          state.selectSubCategory(
            subCategoryId: result.subCategory.id,
            subCategoryName: result.subCategory.name,
            preferCategoryIdForShoppingSelection: preferCategoryId,
          ),
        );
        await loadCategoryProducts(
          overrideSubCategoryId: result.subCategory.id,
          overrideCategoryId: result.category.id,
        );
      case ExternalSubCategoryLoadFailure():
        emit(state.filtersReloadFailed(result.failure));
      case ExternalSubCategoryNotFound():
        return;
    }
  }

  Future<void> _selectShoppingSubCategory({
    required String subCategoryId,
    required String? subCategoryName,
    bool? preferCategoryIdForShoppingSelection,
  }) async {
    final shouldPreferCategoryId =
        preferCategoryIdForShoppingSelection ??
        state.preferCategoryIdForShoppingSelection;
    final targetCategoryId = _navigationHandler.resolveTargetCategoryId(
      state,
      subCategoryId,
    );

    if (targetCategoryId == null || targetCategoryId.isEmpty) {
      emit(
        state.selectSubCategory(
          subCategoryId: subCategoryId,
          subCategoryName: subCategoryName,
          preferCategoryIdForShoppingSelection: shouldPreferCategoryId,
        ),
      );
      await loadCategoryProducts(overrideSubCategoryId: subCategoryId);
      return;
    }

    final category = state.categories.firstWhere(
      (item) => item.id == targetCategoryId,
      orElse: () => buildFallbackCategory(
        id: targetCategoryId,
        name: state.selectedCategory,
      ),
    );

    emit(
      state.selectShoppingSubCategory(
        category: category,
        subCategoryId: subCategoryId,
        subCategoryName: subCategoryName,
        preferCategoryIdForShoppingSelection: shouldPreferCategoryId,
      ),
    );

    final result = await _loaderService.loadFiltersForCategory(
      categoryId: targetCategoryId,
      subCategories: state.subCategories,
      subCategoryCategoryMap: state.subCategoryCategoryMap,
    );
    switch (result) {
      case CategoryFiltersReloadSuccess():
        _emitCategoryFilters(
          result.data.filters,
          subCategories: result.data.subCategories,
          subCategoryCategoryMap: result.data.subCategoryCategoryMap,
        );
        emit(
          state.selectSubCategory(
            subCategoryId: subCategoryId,
            subCategoryName: subCategoryName,
            preferCategoryIdForShoppingSelection: shouldPreferCategoryId,
          ),
        );
        await loadCategoryProducts(
          overrideSubCategoryId: subCategoryId,
          overrideCategoryId: targetCategoryId,
        );
      case CategoryFiltersReloadFailure():
        emit(state.filtersReloadFailed(result.failure));
    }
  }

  Future<void> _retryFiltersAndProducts() async {
    final categoryId = state.selectedCategoryId;
    if (categoryId == null || categoryId.isEmpty) {
      await loadInitialData();
      return;
    }

    final category = state.categories.firstWhere(
      (item) => item.id == categoryId,
      orElse: () =>
          buildFallbackCategory(id: categoryId, name: state.selectedCategory),
    );

    await selectCategory(
      category,
      fromOutside: state.isCategoryPreselectedFromOutside,
      showAllSubCategories: state.showAllSubCategories,
    );
  }

  void _emitCategoryFilters(
    CategoryFiltersResponseModelDto filters, {
    List<CategorySubcategoryItemDto>? subCategories,
    Map<String, String>? subCategoryCategoryMap,
  }) {
    emit(
      state.applyCategoryFilters(
        _filtersService.prepareFilters(filters, subCategories: subCategories),
        subCategoryCategoryMap: subCategoryCategoryMap,
      ),
    );
  }

  void _handlePaginatedProductsResult(
    ApiResult<PaginatedProductsEntity> result,
  ) {
    switch (result) {
      case ApiSuccessResult<PaginatedProductsEntity>():
        emit(
          state.paginatedProductsLoaded(
            items: result.data.items,
            total: result.data.total,
            page: result.data.page,
            hasMore: result.data.hasMore,
          ),
        );
      case ApiErrorResult<PaginatedProductsEntity>():
        emit(state.productsLoadFailed(result.failure));
    }
  }

  bool _shouldChangeCategory(CategoryFilterSelection selection) {
    if (selection.categoryId != null) {
      return selection.categoryId != state.selectedCategoryId;
    }

    return selection.categoryName != null &&
        selection.categoryName != state.selectedCategory;
  }

  @override
  Future<void> close() {
    _isInitialized = false;
    _navigationService.removeListener(_checkSelectedCategory);
    return super.close();
  }
}
