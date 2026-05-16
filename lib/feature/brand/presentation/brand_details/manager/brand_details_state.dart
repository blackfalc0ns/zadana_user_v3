import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/errors/api_exception.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_option_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_sort_option_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_subcategory_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';

class BrandDetailsState {
  const BrandDetailsState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.products = const [],
    this.totalProducts = 0,
    this.currentPage = 1,
    this.hasMore = true,
    this.categories = const [],
    this.subcategories = const [],
    this.units = const [],
    this.packageTypes = const [],
    this.measurementUnits = const [],
    this.measurementValues = const [],
    this.sortOptions = const [],
    this.selectedSortValue = '',
    this.selectedCategoryId,
    this.selectedSubcategoryId,
    this.selectedUnitId,
    this.selectedPackageTypeId,
    this.selectedMeasurementUnitId,
    this.selectedMeasurementValue,
    this.priceRange = const RangeValues(0, 500),
    this.priceBounds = const RangeValues(0, 500),
    this.errorMessage,
    this.exception,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final List<BrandProductModel> products;
  final int totalProducts;
  final int currentPage;
  final bool hasMore;
  final List<BrandFilterOptionEntity> categories;
  final List<BrandFilterSubcategoryEntity> subcategories;
  final List<BrandFilterOptionEntity> units;
  final List<BrandFilterOptionEntity> packageTypes;
  final List<BrandFilterOptionEntity> measurementUnits;
  final List<double> measurementValues;
  final List<BrandFilterSortOptionEntity> sortOptions;
  final String selectedSortValue;
  final String? selectedCategoryId;
  final String? selectedSubcategoryId;
  final String? selectedUnitId;
  final String? selectedPackageTypeId;
  final String? selectedMeasurementUnitId;
  final double? selectedMeasurementValue;
  final RangeValues priceRange;
  final RangeValues priceBounds;
  final String? errorMessage;
  final ApiException? exception;

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
      selectedPackageTypeId != null ||
      selectedMeasurementUnitId != null ||
      selectedMeasurementValue != null ||
      hasActivePriceFilter ||
      selectedSortValue.isNotEmpty;

  BrandDetailsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<BrandProductModel>? products,
    int? totalProducts,
    int? currentPage,
    bool? hasMore,
    List<BrandFilterOptionEntity>? categories,
    List<BrandFilterSubcategoryEntity>? subcategories,
    List<BrandFilterOptionEntity>? units,
    List<BrandFilterOptionEntity>? packageTypes,
    List<BrandFilterOptionEntity>? measurementUnits,
    List<double>? measurementValues,
    List<BrandFilterSortOptionEntity>? sortOptions,
    String? selectedSortValue,
    Object? selectedCategoryId = _sentinel,
    Object? selectedSubcategoryId = _sentinel,
    Object? selectedUnitId = _sentinel,
    Object? selectedPackageTypeId = _sentinel,
    Object? selectedMeasurementUnitId = _sentinel,
    Object? selectedMeasurementValue = _sentinel,
    RangeValues? priceRange,
    RangeValues? priceBounds,
    Object? errorMessage = _sentinel,
    Object? exception = _sentinel,
  }) {
    return BrandDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      products: products ?? this.products,
      totalProducts: totalProducts ?? this.totalProducts,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      categories: categories ?? this.categories,
      subcategories: subcategories ?? this.subcategories,
      units: units ?? this.units,
      packageTypes: packageTypes ?? this.packageTypes,
      measurementUnits: measurementUnits ?? this.measurementUnits,
      measurementValues: measurementValues ?? this.measurementValues,
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
      selectedPackageTypeId: selectedPackageTypeId == _sentinel
          ? this.selectedPackageTypeId
          : selectedPackageTypeId as String?,
      selectedMeasurementUnitId: selectedMeasurementUnitId == _sentinel
          ? this.selectedMeasurementUnitId
          : selectedMeasurementUnitId as String?,
      selectedMeasurementValue: selectedMeasurementValue == _sentinel
          ? this.selectedMeasurementValue
          : selectedMeasurementValue as double?,
      priceRange: priceRange ?? this.priceRange,
      priceBounds: priceBounds ?? this.priceBounds,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
      exception: exception == _sentinel
          ? this.exception
          : exception as ApiException?,
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
