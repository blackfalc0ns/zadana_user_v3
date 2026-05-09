import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_option_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_sort_option_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_subcategory_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';

class BrandDetailsState {
  const BrandDetailsState({
    this.isLoading = false,
    this.products = const [],
    this.totalProducts = 0,
    this.categories = const [],
    this.subcategories = const [],
    this.units = const [],
    this.sortOptions = const [],
    this.selectedSortValue = '',
    this.selectedCategoryId,
    this.selectedSubcategoryId,
    this.selectedUnitId,
    this.priceRange = const RangeValues(0, 500),
    this.priceBounds = const RangeValues(0, 500),
    this.errorMessage,
  });

  final bool isLoading;
  final List<BrandProductModel> products;
  final int totalProducts;
  final List<BrandFilterOptionEntity> categories;
  final List<BrandFilterSubcategoryEntity> subcategories;
  final List<BrandFilterOptionEntity> units;
  final List<BrandFilterSortOptionEntity> sortOptions;
  final String selectedSortValue;
  final String? selectedCategoryId;
  final String? selectedSubcategoryId;
  final String? selectedUnitId;
  final RangeValues priceRange;
  final RangeValues priceBounds;
  final String? errorMessage;

  List<String> get categoryNames => categories
      .map((item) => item.name.trim())
      .where((item) => item.isNotEmpty)
      .toList(growable: false);

  List<String> get unitNames => units
      .map((item) => item.name.trim())
      .where((item) => item.isNotEmpty)
      .toList(growable: false);

  String? get selectedCategoryName =>
      _nameFromOption(categories, selectedCategoryId);

  String? get selectedSubcategoryName =>
      _nameFromSubcategory(subcategories, selectedSubcategoryId);

  String? get selectedUnitName => _nameFromOption(units, selectedUnitId);

  bool get hasActivePriceFilter =>
      priceRange.start != priceBounds.start ||
      priceRange.end != priceBounds.end;

  bool get hasActiveFilters =>
      selectedCategoryId != null ||
      selectedSubcategoryId != null ||
      selectedUnitId != null ||
      hasActivePriceFilter ||
      selectedSortValue.isNotEmpty;

  BrandDetailsState copyWith({
    bool? isLoading,
    List<BrandProductModel>? products,
    int? totalProducts,
    List<BrandFilterOptionEntity>? categories,
    List<BrandFilterSubcategoryEntity>? subcategories,
    List<BrandFilterOptionEntity>? units,
    List<BrandFilterSortOptionEntity>? sortOptions,
    String? selectedSortValue,
    Object? selectedCategoryId = _sentinel,
    Object? selectedSubcategoryId = _sentinel,
    Object? selectedUnitId = _sentinel,
    RangeValues? priceRange,
    RangeValues? priceBounds,
    Object? errorMessage = _sentinel,
  }) {
    return BrandDetailsState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      totalProducts: totalProducts ?? this.totalProducts,
      categories: categories ?? this.categories,
      subcategories: subcategories ?? this.subcategories,
      units: units ?? this.units,
      sortOptions: sortOptions ?? this.sortOptions,
      selectedSortValue: selectedSortValue ?? this.selectedSortValue,
      selectedCategoryId: selectedCategoryId == _sentinel
          ? this.selectedCategoryId
          : selectedCategoryId as String?,
      selectedSubcategoryId: selectedSubcategoryId == _sentinel
          ? this.selectedSubcategoryId
          : selectedSubcategoryId as String?,
      selectedUnitId: selectedUnitId == _sentinel
          ? this.selectedUnitId
          : selectedUnitId as String?,
      priceRange: priceRange ?? this.priceRange,
      priceBounds: priceBounds ?? this.priceBounds,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  static const Object _sentinel = Object();

  static String? _nameFromOption(
    List<BrandFilterOptionEntity> items,
    String? selectedId,
  ) {
    if (selectedId == null || selectedId.isEmpty) {
      return null;
    }

    for (final item in items) {
      if (item.id == selectedId) {
        final name = item.name.trim();
        if (name.isNotEmpty) {
          return name;
        }
      }
    }
    return null;
  }

  static String? _nameFromSubcategory(
    List<BrandFilterSubcategoryEntity> items,
    String? selectedId,
  ) {
    if (selectedId == null || selectedId.isEmpty) {
      return null;
    }

    for (final item in items) {
      if (item.id == selectedId) {
        final name = item.name.trim();
        if (name.isNotEmpty) {
          return name;
        }
      }
    }
    return null;
  }
}
