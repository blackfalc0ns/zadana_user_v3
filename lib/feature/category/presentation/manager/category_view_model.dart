import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/core/services/favorite_sync_service.dart';
import 'package:zadana_user_v3/feature/category/data/mapper/category_products_mapper.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_state.dart';

class CategoryViewModel extends Cubit<CategoryState> {
  CategoryViewModel(
    this._apiServices,
    this._navigationService,
    this._favoriteSyncService,
  ) : super(const CategoryState());

  final ApiServices _apiServices;
  final CategoryNavigationService _navigationService;
  final FavoriteSyncService _favoriteSyncService;

  void initialize() {
    _favoriteSyncService.addListener(_syncFavoriteState);
    _navigationService.addListener(_checkSelectedCategory);
    unawaited(loadInitialData());
  }

  Future<void> loadInitialData() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        failure: null,
        retryAction: CategoryRetryAction.initialLoad,
      ),
    );

    try {
      final response = await _apiServices.getHomeCategories();
      final categories = (response.items ?? const [])
          .where(
            (item) =>
                (item.id ?? '').isNotEmpty && (item.name ?? '').isNotEmpty,
          )
          .map(
            (item) => CategoryEntity(
              id: item.id ?? '',
              name: item.name ?? '',
              imageAsset: item.imageUrl ?? '',
              emoji: (item.name ?? '').substring(0, 1),
            ),
          )
          .toList();

      emit(state.copyWith(categories: categories));

      final selectedFromHome = _navigationService.selectedCategory;
      final initialCategory = _resolveRequestedCategory(selectedFromHome) ??
          (categories.isNotEmpty ? categories.first : null);

      if (initialCategory == null) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'لا توجد أقسام متاحة حاليًا',
            failure: null,
          ),
        );
        return;
      }

      await selectCategory(
        initialCategory,
        fromOutside: selectedFromHome != null,
      );

      if (selectedFromHome != null) {
        _navigationService.clearSelectedCategory();
      }
    } catch (error) {
      final failure = _mapFailure(error);
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: failure.code,
          failure: failure,
          retryAction: CategoryRetryAction.initialLoad,
        ),
      );
    }
  }

  Future<void> selectCategory(
    CategoryEntity category, {
    bool fromOutside = false,
  }) async {
    emit(
      state.copyWith(
        selectedCategory: category.name,
        selectedCategoryId: category.id,
        selectedSubCategory: null,
        selectedSubCategoryId: null,
        subCategories: const [],
        products: const [],
        quantityOptions: const [],
        brandOptions: const [],
        productTypeOptions: const [],
        partOptions: const [],
        sortOptions: const [],
        filterSelectedCategory: category.name,
        filterSelectedQuantity: null,
        filterSelectedBrand: null,
        filterSelectedProductType: null,
        filterSelectedPart: null,
        selectedQuantityId: null,
        selectedBrandId: null,
        selectedProductTypeId: null,
        selectedPartId: null,
        priceBounds: const RangeValues(0, 1000),
        priceRange: const RangeValues(0, 1000),
        isCategoryPreselectedFromOutside: fromOutside,
        isLoading: true,
        isSubCategoriesLoading: true,
        errorMessage: null,
        failure: null,
        retryAction: CategoryRetryAction.loadFiltersAndProducts,
      ),
    );

    try {
      final filters = await _apiServices.getCategoryFilters(category.id);
      _applyCategoryFilters(filters);
      await loadCategoryProducts();
    } catch (error) {
      final failure = _mapFailure(error);
      emit(
        state.copyWith(
          subCategories: const [],
          products: const [],
          quantityOptions: const [],
          brandOptions: const [],
          productTypeOptions: const [],
          partOptions: const [],
          sortOptions: const [],
          selectedSubCategory: null,
          selectedSubCategoryId: null,
          isLoading: false,
          isSubCategoriesLoading: false,
          errorMessage: failure.code,
          failure: failure,
          retryAction: CategoryRetryAction.loadFiltersAndProducts,
        ),
      );
    }
  }

  Future<void> loadCategoryProducts() async {
    final targetId = state.selectedCategoryId;
    if (targetId == null || targetId.isEmpty) return;

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        failure: null,
        retryAction: CategoryRetryAction.loadProducts,
      ),
    );

    try {
      final response = await _apiServices.getCategoryProducts(
        targetId,
        state.selectedSubCategoryId,
        state.selectedProductTypeId,
        state.selectedPartId,
        state.selectedQuantityId,
        state.selectedBrandId,
        state.priceRange.start,
        state.priceRange.end,
        state.selectedSortOption.isEmpty ? null : state.selectedSortOption,
      );
      final products = (response.items ?? const [])
          .map((item) => item.toEntity())
          .toList();

      emit(
        state.copyWith(
          products: products,
          isLoading: false,
          errorMessage: null,
          failure: null,
        ),
      );
    } catch (error) {
      final failure = _mapFailure(error);
      emit(
        state.copyWith(
          products: const [],
          isLoading: false,
          errorMessage: failure.code,
          failure: failure,
          retryAction: CategoryRetryAction.loadProducts,
        ),
      );
    }
  }

  void selectCategoryByName(String categoryName) {
    if (categoryName == state.selectedCategory) return;

    final category = state.categories
        .where((item) => item.name == categoryName)
        .firstWhere((_) => true, orElse: () => const CategoryEntity(id: '', name: '', imageAsset: '', emoji: ''));
    if (category.id.isEmpty) return;

    unawaited(selectCategory(category));
  }

  void selectSubCategory(String? subCategoryId, String? subCategoryName) {
    final isSameSubCategory = state.selectedSubCategoryId == subCategoryId;

    emit(
      state.copyWith(
        selectedSubCategoryId: isSameSubCategory ? null : subCategoryId,
        selectedSubCategory: isSameSubCategory ? null : subCategoryName,
      ),
    );

    unawaited(loadCategoryProducts());
  }

  void applySort(String? sortValue) {
    emit(state.copyWith(selectedSortOption: sortValue ?? ''));
    unawaited(loadCategoryProducts());
  }

  void applyFilters(Map<String, dynamic>? result) {
    if (result == null) return;

    final categoryName = result['category'] as String?;
    if (categoryName != null && categoryName != state.selectedCategory) {
      selectCategoryByName(categoryName);
      return;
    }

    final quantity = result['quantity'] as String?;
    final brand = result['brand'] as String?;
    final productType = result['productType'] as String?;
    final part = result['part'] as String?;
    final priceRange = result['priceRange'] as RangeValues? ?? state.priceBounds;

    emit(
      state.copyWith(
        filterSelectedCategory: categoryName ?? state.filterSelectedCategory,
        filterSelectedQuantity: quantity,
        filterSelectedBrand: brand,
        filterSelectedProductType: productType,
        filterSelectedPart: part,
        selectedQuantityId: _findOptionId(state.quantityOptions, quantity),
        selectedBrandId: _findBrandId(brand),
        selectedProductTypeId:
            _findOptionId(state.productTypeOptions, productType),
        selectedPartId: _findPartId(part),
        priceRange: priceRange,
      ),
    );

    unawaited(loadCategoryProducts());
  }

  void clearAllFilters() {
    emit(
      state.copyWith(
        filterSelectedCategory:
            state.isCategoryPreselectedFromOutside ? state.selectedCategory : null,
        filterSelectedQuantity: null,
        filterSelectedBrand: null,
        filterSelectedProductType: null,
        filterSelectedPart: null,
        selectedQuantityId: null,
        selectedBrandId: null,
        selectedProductTypeId: null,
        selectedPartId: null,
        priceRange: state.priceBounds,
      ),
    );
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
          orElse: () => CategoryEntity(
            id: categoryId,
            name: state.selectedCategory,
            imageAsset: '',
            emoji: state.selectedCategory.isNotEmpty
                ? state.selectedCategory.substring(0, 1)
                : '',
          ),
        );
        unawaited(
          selectCategory(
            category,
            fromOutside: state.isCategoryPreselectedFromOutside,
          ),
        );
      case CategoryRetryAction.loadProducts:
        unawaited(loadCategoryProducts());
    }
  }

  void _applyCategoryFilters(CategoryFiltersResponseModelDto filters) {
    final subCategories = (filters.subcategories ?? const [])
        .where(
          (item) =>
              (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty,
        )
        .toList();
    final quantityOptions = (filters.quantities ?? const [])
        .where(
          (item) =>
              (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty,
        )
        .toList();
    final brandOptions = (filters.brands ?? const [])
        .where(
          (item) =>
              (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty,
        )
        .toList();
    final productTypeOptions = (filters.productTypes ?? const [])
        .where(
          (item) =>
              (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty,
        )
        .toList();
    final partOptions = (filters.parts ?? const [])
        .where(
          (item) =>
              (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty,
        )
        .toList();

    final minPrice = filters.priceRange?.min ?? 0;
    final maxPrice = filters.priceRange?.max ?? minPrice;
    final normalizedMax = maxPrice >= minPrice ? maxPrice : minPrice;
    final priceBounds = RangeValues(minPrice, normalizedMax);

    emit(
      state.copyWith(
        subCategories: subCategories,
        quantityOptions: quantityOptions,
        brandOptions: brandOptions,
        productTypeOptions: productTypeOptions,
        partOptions: partOptions,
        sortOptions: (filters.sortOptions ?? const [])
            .map(
              (item) => {
                'value': item.value ?? '',
                'title': item.label ?? '',
                'subtitle': null,
              },
            )
            .where((item) => (item['value'] as String).isNotEmpty)
            .toList(),
        priceBounds: priceBounds,
        priceRange: priceBounds,
        isSubCategoriesLoading: false,
      ),
    );
  }

  CategoryEntity? _resolveRequestedCategory(CategoryEntity? requested) {
    if (requested == null) return null;

    for (final category in state.categories) {
      if (category.id == requested.id || category.name == requested.name) {
        return category;
      }
    }

    return null;
  }

  void _checkSelectedCategory() {
    final requested = _resolveRequestedCategory(_navigationService.selectedCategory);
    if (requested == null) return;

    unawaited(selectCategory(requested, fromOutside: true));
    _navigationService.clearSelectedCategory();
  }

  void _syncFavoriteState() {
    final productId = _favoriteSyncService.productId;
    final isFavorite = _favoriteSyncService.isFavorite;

    if (productId == null || isFavorite == null) return;

    emit(
      state.copyWith(
        products: state.products
            .map(
              (product) => product.id == productId
                  ? product.copyWith(isFavorite: isFavorite)
                  : product,
            )
            .toList(),
      ),
    );
  }

  String? _findOptionId(
    List<CategoryFilterOptionDto> options,
    String? selectedName,
  ) {
    if (selectedName == null || selectedName.isEmpty) return null;
    return options
        .where((item) => item.name == selectedName)
        .map((item) => item.id)
        .cast<String?>()
        .firstWhere((_) => true, orElse: () => null);
  }

  String? _findBrandId(String? selectedName) {
    if (selectedName == null || selectedName.isEmpty) return null;
    return state.brandOptions
        .where((item) => item.name == selectedName)
        .map((item) => item.id)
        .cast<String?>()
        .firstWhere((_) => true, orElse: () => null);
  }

  String? _findPartId(String? selectedName) {
    if (selectedName == null || selectedName.isEmpty) return null;
    return state.partOptions
        .where((item) => item.name == selectedName)
        .map((item) => item.id)
        .cast<String?>()
        .firstWhere((_) => true, orElse: () => null);
  }

  Failure _mapFailure(Object error) {
    return error is DioException
        ? ServerFailure.fromDioError(dioException: error)
        : Failure(errorMessage: error.toString(), code: 'error_unknown');
  }

  @override
  Future<void> close() {
    _favoriteSyncService.removeListener(_syncFavoriteState);
    _navigationService.removeListener(_checkSelectedCategory);
    return super.close();
  }
}
