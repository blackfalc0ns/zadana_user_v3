import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_brand_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_part_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

enum CategoryRetryAction { initialLoad, loadFiltersAndProducts, loadProducts }

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
    this.isLoading = true,
    this.isSubCategoriesLoading = false,
    this.errorMessage,
    this.failure,
    this.retryAction = CategoryRetryAction.initialLoad,
    this.priceRange = const RangeValues(0, 1000),
    this.priceBounds = const RangeValues(0, 1000),
  });

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
  final bool isLoading;
  final bool isSubCategoriesLoading;
  final String? errorMessage;
  final Failure? failure;
  final CategoryRetryAction retryAction;
  final RangeValues priceRange;
  final RangeValues priceBounds;

  List<String> get availableBrands => brandOptions
      .map((item) => item.name?.trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList();

  List<String> get availableQuantities => quantityOptions
      .map((item) => item.name?.trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList();

  List<String> get availableProductTypes => productTypeOptions
      .map((item) => item.name?.trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList();

  List<String> get availableParts => partOptions
      .where(
        (item) =>
            selectedProductTypeId == null ||
            selectedProductTypeId!.isEmpty ||
            item.productTypeId == selectedProductTypeId,
      )
      .map((item) => item.name?.trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList();

  bool get hasActivePriceFilter =>
      priceRange.start != priceBounds.start || priceRange.end != priceBounds.end;

  bool get hasActiveCategoryFilter =>
      !isCategoryPreselectedFromOutside &&
      filterSelectedCategory != null &&
      filterSelectedCategory != selectedCategory;

  bool get hasActiveFilters =>
      selectedSortOption.isNotEmpty ||
      hasActiveCategoryFilter ||
      filterSelectedQuantity != null ||
      filterSelectedBrand != null ||
      filterSelectedProductType != null ||
      filterSelectedPart != null ||
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
    Object? selectedCategoryId = const Object(),
    Object? selectedSubCategory = const Object(),
    Object? selectedSubCategoryId = const Object(),
    Object? filterSelectedCategory = const Object(),
    Object? filterSelectedQuantity = const Object(),
    Object? filterSelectedBrand = const Object(),
    Object? filterSelectedProductType = const Object(),
    Object? filterSelectedPart = const Object(),
    Object? selectedQuantityId = const Object(),
    Object? selectedBrandId = const Object(),
    Object? selectedProductTypeId = const Object(),
    Object? selectedPartId = const Object(),
    bool? isCategoryPreselectedFromOutside,
    bool? isLoading,
    bool? isSubCategoriesLoading,
    Object? errorMessage = const Object(),
    Object? failure = const Object(),
    CategoryRetryAction? retryAction,
    RangeValues? priceRange,
    RangeValues? priceBounds,
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
      selectedCategoryId: identical(selectedCategoryId, const Object())
          ? this.selectedCategoryId
          : selectedCategoryId as String?,
      selectedSubCategory: identical(selectedSubCategory, const Object())
          ? this.selectedSubCategory
          : selectedSubCategory as String?,
      selectedSubCategoryId: identical(selectedSubCategoryId, const Object())
          ? this.selectedSubCategoryId
          : selectedSubCategoryId as String?,
      filterSelectedCategory: identical(filterSelectedCategory, const Object())
          ? this.filterSelectedCategory
          : filterSelectedCategory as String?,
      filterSelectedQuantity: identical(filterSelectedQuantity, const Object())
          ? this.filterSelectedQuantity
          : filterSelectedQuantity as String?,
      filterSelectedBrand: identical(filterSelectedBrand, const Object())
          ? this.filterSelectedBrand
          : filterSelectedBrand as String?,
      filterSelectedProductType:
          identical(filterSelectedProductType, const Object())
          ? this.filterSelectedProductType
          : filterSelectedProductType as String?,
      filterSelectedPart: identical(filterSelectedPart, const Object())
          ? this.filterSelectedPart
          : filterSelectedPart as String?,
      selectedQuantityId: identical(selectedQuantityId, const Object())
          ? this.selectedQuantityId
          : selectedQuantityId as String?,
      selectedBrandId: identical(selectedBrandId, const Object())
          ? this.selectedBrandId
          : selectedBrandId as String?,
      selectedProductTypeId: identical(selectedProductTypeId, const Object())
          ? this.selectedProductTypeId
          : selectedProductTypeId as String?,
      selectedPartId: identical(selectedPartId, const Object())
          ? this.selectedPartId
          : selectedPartId as String?,
      isCategoryPreselectedFromOutside: isCategoryPreselectedFromOutside ??
          this.isCategoryPreselectedFromOutside,
      isLoading: isLoading ?? this.isLoading,
      isSubCategoriesLoading:
          isSubCategoriesLoading ?? this.isSubCategoriesLoading,
      errorMessage: identical(errorMessage, const Object())
          ? this.errorMessage
          : errorMessage as String?,
      failure: identical(failure, const Object())
          ? this.failure
          : failure as Failure?,
      retryAction: retryAction ?? this.retryAction,
      priceRange: priceRange ?? this.priceRange,
      priceBounds: priceBounds ?? this.priceBounds,
    );
  }
}
