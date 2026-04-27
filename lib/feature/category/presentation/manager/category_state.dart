import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_brand_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_part_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

enum CategoryRetryAction { initialLoad, loadFiltersAndProducts, loadProducts }

class ShoppingSubCategoriesData {
  const ShoppingSubCategoriesData({
    required this.subCategories,
    required this.categoryMap,
  });

  final List<CategorySubcategoryItemDto> subCategories;
  final Map<String, String> categoryMap;
}

class CategoryFiltersData {
  const CategoryFiltersData({
    required this.subCategories,
    required this.quantityOptions,
    required this.brandOptions,
    required this.productTypeOptions,
    required this.partOptions,
    required this.sortOptions,
    required this.priceBounds,
  });

  final List<CategorySubcategoryItemDto> subCategories;
  final List<CategoryFilterOptionDto> quantityOptions;
  final List<CategoryFilterBrandItemDto> brandOptions;
  final List<CategoryFilterOptionDto> productTypeOptions;
  final List<CategoryFilterPartItemDto> partOptions;
  final List<Map<String, dynamic>> sortOptions;
  final RangeValues priceBounds;
}

class CategoryState {
  const CategoryState({
    this.categories = const [],
    this.products = const [],
    this.subCategories = const [],
    this.quantityOptions = const [],
    this.brandOptions = const [],
    this.productTypeOptions = const [],
    this.partOptions = const [],
    this.sortOptions = const [],
    this.selectedCategory = '',
    this.selectedSortOption = '',
    this.selectedCategoryId,
    this.selectedSubCategory,
    this.selectedSubCategoryId,
    this.filterSelectedCategory,
    this.filterSelectedQuantity,
    this.filterSelectedBrand,
    this.filterSelectedProductType,
    this.filterSelectedPart,
    this.selectedQuantityId,
    this.selectedBrandId,
    this.selectedProductTypeId,
    this.selectedPartId,
    this.isCategoryPreselectedFromOutside = false,
    this.showAllSubCategories = false,
    this.subCategoryCategoryMap = const {},
    this.isLoading = true,
    this.isSubCategoriesLoading = false,
    this.errorMessage,
    this.failure,
    this.retryAction = CategoryRetryAction.initialLoad,
    this.priceRange = const RangeValues(0, 1000),
    this.priceBounds = const RangeValues(0, 1000),
    this.activeHeroProductId,
  });

  static const _unset = Object();

  final List<CategoryEntity> categories;
  final List<ProductModel> products;
  final List<CategorySubcategoryItemDto> subCategories;
  final List<CategoryFilterOptionDto> quantityOptions;
  final List<CategoryFilterBrandItemDto> brandOptions;
  final List<CategoryFilterOptionDto> productTypeOptions;
  final List<CategoryFilterPartItemDto> partOptions;
  final List<Map<String, dynamic>> sortOptions;
  final String selectedCategory;
  final String selectedSortOption;
  final String? selectedCategoryId;
  final String? selectedSubCategory;
  final String? selectedSubCategoryId;
  final String? filterSelectedCategory;
  final String? filterSelectedQuantity;
  final String? filterSelectedBrand;
  final String? filterSelectedProductType;
  final String? filterSelectedPart;
  final String? selectedQuantityId;
  final String? selectedBrandId;
  final String? selectedProductTypeId;
  final String? selectedPartId;
  final bool isCategoryPreselectedFromOutside;
  final bool showAllSubCategories;
  final Map<String, String> subCategoryCategoryMap;
  final bool isLoading;
  final bool isSubCategoriesLoading;
  final String? errorMessage;
  final Failure? failure;
  final CategoryRetryAction retryAction;
  final RangeValues priceRange;
  final RangeValues priceBounds;
  final String? activeHeroProductId;

  bool get isShoppingMode =>
      showAllSubCategories && !isCategoryPreselectedFromOutside;

  bool get needsDefaultShoppingRetry =>
      showAllSubCategories &&
      !isCategoryPreselectedFromOutside &&
      (selectedCategoryId == null || selectedCategoryId!.isEmpty);

  List<String> get availableBrands => brandOptions
      .map((item) => item.name?.trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList(growable: false);

  List<String> get availableQuantities => quantityOptions
      .map((item) => item.name?.trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList(growable: false);

  List<String> get availableProductTypes => productTypeOptions
      .map((item) => item.name?.trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList(growable: false);

  List<String> get availableParts => partOptions
      .where(
        (item) =>
            selectedProductTypeId == null ||
            selectedProductTypeId!.isEmpty ||
            item.productTypeId == selectedProductTypeId,
      )
      .map((item) => item.name?.trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList(growable: false);

  bool get hasActivePriceFilter =>
      priceRange.start != priceBounds.start || priceRange.end != priceBounds.end;

  bool get hasActiveCategoryFilter =>
      !isCategoryPreselectedFromOutside &&
      filterSelectedCategory != null &&
      filterSelectedCategory != selectedCategory;

  bool get hasNonCategoryActiveFilters =>
      selectedSortOption.isNotEmpty ||
      hasActiveCategoryFilter ||
      filterSelectedQuantity != null ||
      filterSelectedBrand != null ||
      filterSelectedProductType != null ||
      filterSelectedPart != null ||
      hasActivePriceFilter;

  bool get hasActiveFilters =>
      hasNonCategoryActiveFilters ||
      selectedSubCategoryId != null ||
      hasActivePriceFilter;

  CategoryState copyWith({
    List<CategoryEntity>? categories,
    List<ProductModel>? products,
    List<CategorySubcategoryItemDto>? subCategories,
    List<CategoryFilterOptionDto>? quantityOptions,
    List<CategoryFilterBrandItemDto>? brandOptions,
    List<CategoryFilterOptionDto>? productTypeOptions,
    List<CategoryFilterPartItemDto>? partOptions,
    List<Map<String, dynamic>>? sortOptions,
    String? selectedCategory,
    String? selectedSortOption,
    Object? selectedCategoryId = _unset,
    Object? selectedSubCategory = _unset,
    Object? selectedSubCategoryId = _unset,
    Object? filterSelectedCategory = _unset,
    Object? filterSelectedQuantity = _unset,
    Object? filterSelectedBrand = _unset,
    Object? filterSelectedProductType = _unset,
    Object? filterSelectedPart = _unset,
    Object? selectedQuantityId = _unset,
    Object? selectedBrandId = _unset,
    Object? selectedProductTypeId = _unset,
    Object? selectedPartId = _unset,
    bool? isCategoryPreselectedFromOutside,
    bool? showAllSubCategories,
    Map<String, String>? subCategoryCategoryMap,
    bool? isLoading,
    bool? isSubCategoriesLoading,
    Object? errorMessage = _unset,
    Object? failure = _unset,
    CategoryRetryAction? retryAction,
    RangeValues? priceRange,
    RangeValues? priceBounds,
    Object? activeHeroProductId = _unset,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      subCategories: subCategories ?? this.subCategories,
      quantityOptions: quantityOptions ?? this.quantityOptions,
      brandOptions: brandOptions ?? this.brandOptions,
      productTypeOptions: productTypeOptions ?? this.productTypeOptions,
      partOptions: partOptions ?? this.partOptions,
      sortOptions: sortOptions ?? this.sortOptions,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
      selectedCategoryId: identical(selectedCategoryId, _unset)
          ? this.selectedCategoryId
          : selectedCategoryId as String?,
      selectedSubCategory: identical(selectedSubCategory, _unset)
          ? this.selectedSubCategory
          : selectedSubCategory as String?,
      selectedSubCategoryId: identical(selectedSubCategoryId, _unset)
          ? this.selectedSubCategoryId
          : selectedSubCategoryId as String?,
      filterSelectedCategory: identical(filterSelectedCategory, _unset)
          ? this.filterSelectedCategory
          : filterSelectedCategory as String?,
      filterSelectedQuantity: identical(filterSelectedQuantity, _unset)
          ? this.filterSelectedQuantity
          : filterSelectedQuantity as String?,
      filterSelectedBrand: identical(filterSelectedBrand, _unset)
          ? this.filterSelectedBrand
          : filterSelectedBrand as String?,
      filterSelectedProductType: identical(filterSelectedProductType, _unset)
          ? this.filterSelectedProductType
          : filterSelectedProductType as String?,
      filterSelectedPart: identical(filterSelectedPart, _unset)
          ? this.filterSelectedPart
          : filterSelectedPart as String?,
      selectedQuantityId: identical(selectedQuantityId, _unset)
          ? this.selectedQuantityId
          : selectedQuantityId as String?,
      selectedBrandId: identical(selectedBrandId, _unset)
          ? this.selectedBrandId
          : selectedBrandId as String?,
      selectedProductTypeId: identical(selectedProductTypeId, _unset)
          ? this.selectedProductTypeId
          : selectedProductTypeId as String?,
      selectedPartId: identical(selectedPartId, _unset)
          ? this.selectedPartId
          : selectedPartId as String?,
      isCategoryPreselectedFromOutside:
          isCategoryPreselectedFromOutside ??
          this.isCategoryPreselectedFromOutside,
      showAllSubCategories: showAllSubCategories ?? this.showAllSubCategories,
      subCategoryCategoryMap:
          subCategoryCategoryMap ?? this.subCategoryCategoryMap,
      isLoading: isLoading ?? this.isLoading,
      isSubCategoriesLoading:
          isSubCategoriesLoading ?? this.isSubCategoriesLoading,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      failure: identical(failure, _unset) ? this.failure : failure as Failure?,
      retryAction: retryAction ?? this.retryAction,
      priceRange: priceRange ?? this.priceRange,
      priceBounds: priceBounds ?? this.priceBounds,
      activeHeroProductId: identical(activeHeroProductId, _unset)
          ? this.activeHeroProductId
          : activeHeroProductId as String?,
    );
  }

  CategoryState startInitialLoad() => copyWith(
    isLoading: true,
    errorMessage: null,
    failure: null,
    retryAction: CategoryRetryAction.initialLoad,
  );

  CategoryState initialLoadFailed(Failure value) => copyWith(
    isLoading: false,
    errorMessage: value.code,
    failure: value,
    retryAction: CategoryRetryAction.initialLoad,
  );

  CategoryState defaultShoppingLoadFailed(Failure value) => copyWith(
    products: const [],
    subCategories: const [],
    isLoading: false,
    isSubCategoriesLoading: false,
    errorMessage: value.code,
    failure: value,
    retryAction: CategoryRetryAction.initialLoad,
  );

  CategoryState missingRequestedCategory() =>
      copyWith(isLoading: false, errorMessage: '', failure: null);

  CategoryState selectingCategory({
    required CategoryEntity category,
    required bool fromOutside,
    required bool showAllSubCategories,
  }) => copyWith(
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
    selectedSortOption: '',
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

  CategoryState startProductsLoad() => copyWith(
    isLoading: true,
    errorMessage: null,
    failure: null,
    retryAction: CategoryRetryAction.loadProducts,
  );

  CategoryState productsLoaded(List<ProductModel> value) => copyWith(
    products: value,
    isLoading: false,
    errorMessage: null,
    failure: null,
  );

  CategoryState productsLoadFailed(Failure value) => copyWith(
    products: const [],
    isLoading: false,
    errorMessage: value.code,
    failure: value,
    retryAction: CategoryRetryAction.loadProducts,
  );

  CategoryState selectSubCategory({
    required String? subCategoryId,
    required String? subCategoryName,
  }) => copyWith(
    selectedSubCategoryId: subCategoryId,
    selectedSubCategory: subCategoryName,
  );

  CategoryState applyFilterSelection({
    required String? categoryName,
    required String? subCategoryId,
    required String? subCategoryName,
    required String? quantity,
    required String? brand,
    required String? productType,
    required String? part,
    required RangeValues priceRange,
  }) => copyWith(
    filterSelectedCategory: categoryName ?? filterSelectedCategory,
    filterSelectedQuantity: quantity,
    filterSelectedBrand: brand,
    filterSelectedProductType: productType,
    filterSelectedPart: part,
    selectedSubCategoryId: subCategoryId,
    selectedSubCategory: subCategoryName,
    selectedQuantityId: _findOptionId(quantityOptions, quantity),
    selectedBrandId: _findBrandId(brandOptions, brand),
    selectedProductTypeId: _findOptionId(productTypeOptions, productType),
    selectedPartId: _findPartId(partOptions, part),
    priceRange: priceRange,
  );

  CategoryState clearFilters() => copyWith(
    selectedSortOption: '',
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

  CategoryState applyCategoryFilters(
    CategoryFiltersData data, {
    Map<String, String>? subCategoryCategoryMap,
  }) => copyWith(
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

  CategoryState selectShoppingSubCategory({
    required CategoryEntity category,
    required String subCategoryId,
    required String? subCategoryName,
  }) => copyWith(
    selectedCategory: category.name,
    selectedCategoryId: category.id,
    filterSelectedCategory: category.name,
    selectedSubCategoryId: subCategoryId,
    selectedSubCategory: subCategoryName,
    selectedSortOption: '',
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

  CategoryState startDefaultShoppingView(List<CategoryEntity> value) => copyWith(
    categories: value,
    selectedCategory: '',
    selectedSortOption: '',
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

  CategoryState loadedShoppingSubCategories(ShoppingSubCategoriesData data) =>
      copyWith(
        subCategories: data.subCategories,
        subCategoryCategoryMap: data.categoryMap,
        isSubCategoriesLoading: false,
      );

  CategoryState filtersReloadFailed(Failure value) => copyWith(
    products: const [],
    isLoading: false,
    errorMessage: value.code,
    failure: value,
    retryAction: CategoryRetryAction.loadFiltersAndProducts,
  );

  CategoryState syncFavoriteState({
    required String productId,
    required bool isFavorite,
  }) => copyWith(
    products: products
        .map(
          (product) => product.id == productId
              ? product.copyWith(isFavorite: isFavorite)
              : product,
        )
        .toList(growable: false),
  );

  CategoryState filtersAndProductsFailed(Failure value) => copyWith(
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
    errorMessage: value.code,
    failure: value,
    retryAction: CategoryRetryAction.loadFiltersAndProducts,
  );
}

String? _findOptionId(
  List<CategoryFilterOptionDto> options,
  String? selectedName,
) {
  return _findItemId(
    options,
    selectedName,
    nameOf: (item) => item.name,
    idOf: (item) => item.id,
  );
}

String? _findBrandId(
  List<CategoryFilterBrandItemDto> options,
  String? selectedName,
) {
  return _findItemId(
    options,
    selectedName,
    nameOf: (item) => item.name,
    idOf: (item) => item.id,
  );
}

String? _findPartId(
  List<CategoryFilterPartItemDto> options,
  String? selectedName,
) {
  return _findItemId(
    options,
    selectedName,
    nameOf: (item) => item.name,
    idOf: (item) => item.id,
  );
}

String? _findItemId<T>(
  List<T> options,
  String? selectedName, {
  required String? Function(T item) nameOf,
  required String? Function(T item) idOf,
}) {
  if (selectedName == null || selectedName.isEmpty) {
    return null;
  }

  for (final option in options) {
    if (nameOf(option) == selectedName) {
      return idOf(option);
    }
  }

  return null;
}
