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
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
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
      final selectedSubCategoryId = _navigationService.selectedSubCategoryId;
      final selectedSubCategoryName =
          _navigationService.selectedSubCategoryName;
      final hasRequestedSubCategory =
          (selectedSubCategoryId?.isNotEmpty ?? false) ||
          (selectedSubCategoryName?.isNotEmpty ?? false);
      final initialCategory = _resolveRequestedCategory(selectedFromHome);

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
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'لا توجد أقسام متاحة حاليًا',
            failure: null,
          ),
        );
        return;
      }

      await selectCategory(initialCategory, fromOutside: true);

      _navigationService.clearSelectedCategory();
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
    bool showAllSubCategories = false,
  }) async {
    emit(
      state.copyWith(
        selectedCategory: category.name,
        selectedCategoryId: category.id,
        selectedSubCategory: null,
        selectedSubCategoryId: null,
        subCategories: const [],
        subCategoryCategoryMap: const {},
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
        showAllSubCategories: showAllSubCategories,
        isLoading: true,
        isSubCategoriesLoading: true,
        errorMessage: null,
        failure: null,
        retryAction: CategoryRetryAction.loadFiltersAndProducts,
      ),
    );

    try {
      if (showAllSubCategories) {
        final categoryFilters = await Future.wait(
          state.categories
              .map((item) => _apiServices.getCategoryFilters(item.id))
              .toList(growable: false),
        );
        final selectedFilters = categoryFilters.firstWhere(
          (filters) => filters.category?.id == category.id,
          orElse: () => categoryFilters.first,
        );
        final shoppingSubCategories = _buildShoppingSubCategories(
          categories: state.categories,
          categoryFilters: categoryFilters,
        );
        _applyCategoryFilters(
          selectedFilters,
          subCategories: shoppingSubCategories.subCategories,
          subCategoryCategoryMap: shoppingSubCategories.categoryMap,
        );
      } else {
        final results = await Future.wait<dynamic>([
          _apiServices.getCategoryFilters(category.id),
          _apiServices.getCategorySubcategories(category.id),
        ]);
        final filters = results[0] as CategoryFiltersResponseModelDto;
        final subCategories = results[1] as List<CategorySubcategoryItemDto>;
        _applyCategoryFilters(
          filters,
          subCategories: subCategories,
          subCategoryCategoryMap: {
            for (final item in subCategories)
              if ((item.id ?? '').isNotEmpty) item.id!: category.id,
          },
        );
      }
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

    final requestCategoryId =
        overrideCategoryId ??
        _resolveCategoryIdForSubCategory(effectiveSubCategoryId) ??
        state.selectedCategoryId;
    if (requestCategoryId == null || requestCategoryId.isEmpty) return;

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
        requestCategoryId,
        effectiveSubCategoryId,
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
        .firstWhere(
          (_) => true,
          orElse: () =>
              const CategoryEntity(id: '', name: '', imageAsset: '', emoji: ''),
        );
    if (category.id.isEmpty) return;

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
      state.copyWith(
        selectedSubCategoryId: nextSubCategoryId,
        selectedSubCategory: nextSubCategoryName,
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
      state.copyWith(
        filterSelectedCategory: categoryName ?? state.filterSelectedCategory,
        filterSelectedQuantity: quantity,
        filterSelectedBrand: brand,
        filterSelectedProductType: productType,
        filterSelectedPart: part,
        selectedSubCategoryId: subCategoryId,
        selectedSubCategory: subCategoryName,
        selectedQuantityId: _findOptionId(state.quantityOptions, quantity),
        selectedBrandId: _findBrandId(brand),
        selectedProductTypeId: _findOptionId(
          state.productTypeOptions,
          productType,
        ),
        selectedPartId: _findPartId(part),
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
    final category = state.categories
        .where((item) => item.name == categoryName)
        .firstWhere(
          (_) => true,
          orElse: () =>
              const CategoryEntity(id: '', name: '', imageAsset: '', emoji: ''),
        );
    if (category.id.isEmpty) return;

    await selectCategory(category);

    if (subCategoryId == null || subCategoryId.isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        selectedSubCategoryId: subCategoryId,
        selectedSubCategory: subCategoryName,
      ),
    );
    await loadCategoryProducts(overrideSubCategoryId: subCategoryId);
  }

  void clearAllFilters() {
    if (state.showAllSubCategories && !state.isCategoryPreselectedFromOutside) {
      unawaited(_loadDefaultShoppingView(categories: state.categories));
      return;
    }

    emit(
      state.copyWith(
        filterSelectedCategory: state.isCategoryPreselectedFromOutside
            ? state.selectedCategory
            : null,
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
    final resolvedSubCategories =
        (subCategories ?? filters.subcategories ?? const [])
            .where(
              (item) =>
                  (item.id ?? '').isNotEmpty &&
                  (item.name ?? '').trim().isNotEmpty,
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
        subCategories: resolvedSubCategories,
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
        subCategoryCategoryMap:
            subCategoryCategoryMap ?? state.subCategoryCategoryMap,
        isSubCategoriesLoading: false,
      ),
    );
  }

  Future<void> _selectShoppingSubCategory({
    required String subCategoryId,
    required String? subCategoryName,
  }) async {
    final targetCategoryId = _resolveCategoryIdForSubCategory(subCategoryId);
    if (targetCategoryId == null || targetCategoryId.isEmpty) {
      emit(
        state.copyWith(
          selectedSubCategoryId: subCategoryId,
          selectedSubCategory: subCategoryName,
        ),
      );
      await loadCategoryProducts(overrideSubCategoryId: subCategoryId);
      return;
    }

    final category = state.categories.firstWhere(
      (item) => item.id == targetCategoryId,
      orElse: () => CategoryEntity(
        id: targetCategoryId,
        name: state.selectedCategory,
        imageAsset: '',
        emoji: '',
      ),
    );

    emit(
      state.copyWith(
        selectedCategory: category.name,
        selectedCategoryId: category.id,
        filterSelectedCategory: category.name,
        selectedSubCategoryId: subCategoryId,
        selectedSubCategory: subCategoryName,
        filterSelectedQuantity: null,
        filterSelectedBrand: null,
        filterSelectedProductType: null,
        filterSelectedPart: null,
        selectedQuantityId: null,
        selectedBrandId: null,
        selectedProductTypeId: null,
        selectedPartId: null,
        isLoading: true,
        errorMessage: null,
        failure: null,
        retryAction: CategoryRetryAction.loadFiltersAndProducts,
      ),
    );

    try {
      final filters = await _apiServices.getCategoryFilters(targetCategoryId);
      _applyCategoryFilters(
        filters,
        subCategories: state.subCategories,
        subCategoryCategoryMap: state.subCategoryCategoryMap,
      );
      emit(
        state.copyWith(
          selectedSubCategoryId: subCategoryId,
          selectedSubCategory: subCategoryName,
        ),
      );
      await loadCategoryProducts(
        overrideSubCategoryId: subCategoryId,
        overrideCategoryId: targetCategoryId,
      );
    } catch (error) {
      final failure = _mapFailure(error);
      emit(
        state.copyWith(
          products: const [],
          isLoading: false,
          errorMessage: failure.code,
          failure: failure,
          retryAction: CategoryRetryAction.loadFiltersAndProducts,
        ),
      );
    }
  }

  String? _resolveCategoryIdForSubCategory(String? subCategoryId) {
    if (subCategoryId == null || subCategoryId.isEmpty) {
      return state.selectedCategoryId;
    }

    return state.showAllSubCategories
        ? state.subCategoryCategoryMap[subCategoryId] ??
              state.selectedCategoryId
        : state.selectedCategoryId;
  }

  _ShoppingSubCategoriesData _buildShoppingSubCategories({
    required List<CategoryEntity> categories,
    required List<CategoryFiltersResponseModelDto> categoryFilters,
  }) {
    final items = <CategorySubcategoryItemDto>[];
    final categoryMap = <String, String>{};

    for (var i = 0; i < categoryFilters.length; i++) {
      final categoryId = i < categories.length
          ? categories[i].id
          : (categoryFilters[i].category?.id ?? '');
      if (categoryId.isEmpty) continue;

      for (final item in categoryFilters[i].subcategories ?? const []) {
        final id = item.id ?? '';
        final name = item.name?.trim() ?? '';
        if (id.isEmpty || name.isEmpty || categoryMap.containsKey(id)) {
          continue;
        }
        items.add(item);
        categoryMap[id] = categoryId;
      }
    }

    return _ShoppingSubCategoriesData(
      subCategories: items,
      categoryMap: categoryMap,
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

  Future<void> _loadDefaultShoppingView({
    required List<CategoryEntity> categories,
  }) async {
    emit(
      state.copyWith(
        categories: categories,
        selectedCategory: '',
        selectedCategoryId: null,
        selectedSubCategory: null,
        selectedSubCategoryId: null,
        subCategories: const [],
        subCategoryCategoryMap: const {},
        products: const [],
        quantityOptions: const [],
        brandOptions: const [],
        productTypeOptions: const [],
        partOptions: const [],
        sortOptions: const [],
        filterSelectedCategory: null,
        filterSelectedQuantity: null,
        filterSelectedBrand: null,
        filterSelectedProductType: null,
        filterSelectedPart: null,
        selectedQuantityId: null,
        selectedBrandId: null,
        selectedProductTypeId: null,
        selectedPartId: null,
        isCategoryPreselectedFromOutside: false,
        showAllSubCategories: true,
        priceBounds: const RangeValues(0, 1000),
        priceRange: const RangeValues(0, 1000),
        isLoading: true,
        isSubCategoriesLoading: true,
        errorMessage: null,
        failure: null,
        retryAction: CategoryRetryAction.initialLoad,
      ),
    );

    try {
      final categoryFilters = await Future.wait(
        categories
            .map((item) => _apiServices.getCategoryFilters(item.id))
            .toList(growable: false),
      );
      final shoppingSubCategories = _buildShoppingSubCategories(
        categories: categories,
        categoryFilters: categoryFilters,
      );

      emit(
        state.copyWith(
          subCategories: shoppingSubCategories.subCategories,
          subCategoryCategoryMap: shoppingSubCategories.categoryMap,
          isSubCategoriesLoading: false,
        ),
      );

      await _loadShoppingProducts();
    } catch (error) {
      final failure = _mapFailure(error);
      emit(
        state.copyWith(
          products: const [],
          subCategories: const [],
          isLoading: false,
          isSubCategoriesLoading: false,
          errorMessage: failure.code,
          failure: failure,
          retryAction: CategoryRetryAction.initialLoad,
        ),
      );
    }
  }

  Future<void> _loadShoppingProducts({String? subcategoryId}) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        failure: null,
        retryAction: CategoryRetryAction.loadProducts,
      ),
    );

    try {
      final hasPriceFilter = state.priceRange != state.priceBounds;
      final response = await _apiServices.getShoppingProducts(
        subcategoryId,
        state.selectedProductTypeId,
        state.selectedPartId,
        state.selectedQuantityId,
        state.selectedBrandId,
        hasPriceFilter ? state.priceRange.start : null,
        hasPriceFilter ? state.priceRange.end : null,
        state.selectedSortOption.isEmpty ? null : state.selectedSortOption,
        1,
        20,
      );

      emit(
        state.copyWith(
          products: (response.items ?? const [])
              .map((item) => item.toEntity())
              .toList(),
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

  void _checkSelectedCategory() {
    final requested = _resolveRequestedCategory(
      _navigationService.selectedCategory,
    );
    if (requested == null) {
      final selectedSubCategoryId = _navigationService.selectedSubCategoryId;
      final selectedSubCategoryName =
          _navigationService.selectedSubCategoryName;
      final hasRequestedSubCategory =
          (selectedSubCategoryId?.isNotEmpty ?? false) ||
          (selectedSubCategoryName?.isNotEmpty ?? false);

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

    final requestedSubCategory = _resolveRequestedSubCategory(
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

  CategorySubcategoryItemDto? _resolveRequestedSubCategory({
    String? subCategoryId,
    String? subCategoryName,
  }) {
    final normalizedId = subCategoryId?.trim();
    if (normalizedId != null && normalizedId.isNotEmpty) {
      for (final subCategory in state.subCategories) {
        if (subCategory.id == normalizedId) {
          return subCategory;
        }
      }
    }

    final normalizedName = subCategoryName?.trim().toLowerCase();
    if (normalizedName == null || normalizedName.isEmpty) {
      return null;
    }

    for (final subCategory in state.subCategories) {
      final candidateName = subCategory.name?.trim().toLowerCase();
      if (candidateName == normalizedName) {
        return subCategory;
      }
    }

    return null;
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

class _ShoppingSubCategoriesData {
  const _ShoppingSubCategoriesData({
    required this.subCategories,
    required this.categoryMap,
  });

  final List<CategorySubcategoryItemDto> subCategories;
  final Map<String, String> categoryMap;
}
