import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_state.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_view_model_support.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

extension CategoryStateX on CategoryState {
  CategoryState withSearchQuery(String query) {
    final hasQuery = query.trim().isNotEmpty;
    return copyWith(
      isSearchActive: hasQuery,
      hasSearchQuery: hasQuery,
      showSearchResults: hasQuery ? showSearchResults : false,
    );
  }

  CategoryState closeSearchUi() {
    return copyWith(
      isSearchActive: false,
      hasSearchQuery: false,
      showSearchResults: false,
    );
  }

  CategoryState syncSearchPresentation({
    required bool hasQuery,
    required bool isLoading,
    required bool hasItems,
    required bool hasFailure,
  }) {
    final shouldShowSearchResults =
        isSearchActive && hasQuery && !(isLoading && !hasItems && !hasFailure);

    return copyWith(
      hasSearchQuery: hasQuery,
      showSearchResults: shouldShowSearchResults,
    );
  }

  CategoryState startInitialLoad() {
    return copyWith(
      isLoading: true,
      errorMessage: null,
      failure: null,
      retryAction: CategoryRetryAction.initialLoad,
    );
  }

  CategoryState initialLoadFailed(Failure failure) {
    return copyWith(
      isLoading: false,
      errorMessage: failure.code,
      failure: failure,
      retryAction: CategoryRetryAction.initialLoad,
    );
  }

  CategoryState defaultShoppingLoadFailed(Failure failure) {
    return copyWith(
      products: const [],
      subCategories: const [],
      isLoading: false,
      isSubCategoriesLoading: false,
      errorMessage: failure.code,
      failure: failure,
      retryAction: CategoryRetryAction.initialLoad,
    );
  }

  CategoryState missingRequestedCategory() {
    return copyWith(isLoading: false, errorMessage: '', failure: null);
  }

  CategoryState selectingCategory({
    required CategoryEntity category,
    required bool fromOutside,
    required bool showAllSubCategories,
  }) {
    return copyWith(
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
    );
  }

  CategoryState startProductsLoad() {
    return copyWith(
      isLoading: true,
      errorMessage: null,
      failure: null,
      retryAction: CategoryRetryAction.loadProducts,
    );
  }

  CategoryState productsLoaded(List<ProductModel> products) {
    return copyWith(
      products: products,
      isLoading: false,
      errorMessage: null,
      failure: null,
    );
  }

  CategoryState productsLoadFailed(Failure failure) {
    return copyWith(
      products: const [],
      isLoading: false,
      errorMessage: failure.code,
      failure: failure,
      retryAction: CategoryRetryAction.loadProducts,
    );
  }

  CategoryState selectSubCategory({
    required String? subCategoryId,
    required String? subCategoryName,
  }) {
    return copyWith(
      selectedSubCategoryId: subCategoryId,
      selectedSubCategory: subCategoryName,
    );
  }

  CategoryState applyFilterSelection({
    required String? categoryName,
    required String? subCategoryId,
    required String? subCategoryName,
    required String? quantity,
    required String? brand,
    required String? productType,
    required String? part,
    required RangeValues priceRange,
  }) {
    return copyWith(
      filterSelectedCategory: categoryName ?? filterSelectedCategory,
      filterSelectedQuantity: quantity,
      filterSelectedBrand: brand,
      filterSelectedProductType: productType,
      filterSelectedPart: part,
      selectedSubCategoryId: subCategoryId,
      selectedSubCategory: subCategoryName,
      selectedQuantityId: CategoryViewModelSupport.findOptionId(
        quantityOptions,
        quantity,
      ),
      selectedBrandId: CategoryViewModelSupport.findBrandId(brandOptions, brand),
      selectedProductTypeId: CategoryViewModelSupport.findOptionId(
        productTypeOptions,
        productType,
      ),
      selectedPartId: CategoryViewModelSupport.findPartId(partOptions, part),
      priceRange: priceRange,
    );
  }

  CategoryState clearFilters() {
    return copyWith(
      filterSelectedCategory: isCategoryPreselectedFromOutside
          ? selectedCategory
          : null,
      filterSelectedQuantity: null,
      filterSelectedBrand: null,
      filterSelectedProductType: null,
      filterSelectedPart: null,
      selectedQuantityId: null,
      selectedBrandId: null,
      selectedProductTypeId: null,
      selectedPartId: null,
      priceRange: priceBounds,
    );
  }

  CategoryState applyCategoryFilters(
    CategoryViewModelFiltersStateData data, {
    Map<String, String>? subCategoryCategoryMap,
  }) {
    return copyWith(
      subCategories: data.subCategories,
      quantityOptions: data.quantityOptions,
      brandOptions: data.brandOptions,
      productTypeOptions: data.productTypeOptions,
      partOptions: data.partOptions,
      sortOptions: data.sortOptions,
      priceBounds: data.priceBounds,
      priceRange: data.priceBounds,
      subCategoryCategoryMap: subCategoryCategoryMap ?? this.subCategoryCategoryMap,
      isSubCategoriesLoading: false,
    );
  }

  CategoryState selectShoppingSubCategory({
    required CategoryEntity category,
    required String subCategoryId,
    required String? subCategoryName,
  }) {
    return copyWith(
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
    );
  }

  CategoryState startDefaultShoppingView(List<CategoryEntity> categories) {
    return copyWith(
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
    );
  }

  CategoryState loadedShoppingSubCategories(ShoppingSubCategoriesData data) {
    return copyWith(
      subCategories: data.subCategories,
      subCategoryCategoryMap: data.categoryMap,
      isSubCategoriesLoading: false,
    );
  }

  CategoryState filtersReloadFailed(Failure failure) {
    return copyWith(
      products: const [],
      isLoading: false,
      errorMessage: failure.code,
      failure: failure,
      retryAction: CategoryRetryAction.loadFiltersAndProducts,
    );
  }

  CategoryState syncFavoriteState({
    required String productId,
    required bool isFavorite,
  }) {
    return copyWith(
      products: products
          .map(
            (product) => product.id == productId
                ? product.copyWith(isFavorite: isFavorite)
                : product,
          )
          .toList(growable: false),
    );
  }

  CategoryState filtersAndProductsFailed(Failure failure) {
    return copyWith(
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
    );
  }
}
