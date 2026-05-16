import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_option_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filters_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_products_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_products_request_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/usecase/get_brand_filters_usecase.dart';
import 'package:zadana_user_v3/feature/brand/domain/usecase/get_brand_products_usecase.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand_details/manager/brand_details_state.dart';

@injectable
class BrandDetailsCubit extends Cubit<BrandDetailsState> {
  BrandDetailsCubit(
    this._getBrandFiltersUseCase,
    this._getBrandProductsUseCase,
    @factoryParam this._brand,
  ) : super(const BrandDetailsState());

  static const int _perPage = 20;

  final BrandModel _brand;
  final GetBrandFiltersUseCase _getBrandFiltersUseCase;
  final GetBrandProductsUseCase _getBrandProductsUseCase;

  Future<void> loadInitial() async {
    emit(state.copyWith(isLoading: true, errorMessage: null, exception: null));

    final result = await _getBrandFiltersUseCase(_brand.id);
    switch (result) {
      case ApiSuccessResult<BrandFiltersEntity>():
        final filters = result.data;
        final minPrice = filters.priceRange.min;
        final maxPrice = filters.priceRange.max >= minPrice
            ? filters.priceRange.max
            : minPrice;
        final priceBounds = RangeValues(minPrice, maxPrice);

        emit(
          state.copyWith(
            isLoading: true,
            categories: filters.categories,
            subcategories: filters.subcategories,
            units: filters.units,
            packageTypes: filters.packageTypes,
            measurementUnits: filters.measurementUnits,
            measurementValues: filters.measurementValues,
            sortOptions: filters.sortOptions,
            priceBounds: priceBounds,
            priceRange: priceBounds,
            errorMessage: null,
            exception: null,
          ),
        );
        await _loadProducts();
      case ApiErrorResult<BrandFiltersEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            products: const [],
            categories: const [],
            subcategories: const [],
            units: const [],
            packageTypes: const [],
            measurementUnits: const [],
            measurementValues: const [],
            sortOptions: const [],
            errorMessage: result.failure.errorMessage,
            exception: result.failure.exception,
          ),
        );
    }
  }

  Future<void> selectCategoryByName(String? categoryName) async {
    emit(
      state.copyWith(
        selectedCategoryId: _findOptionIdByName(state.categories, categoryName),
        selectedSubcategoryId: null,
        errorMessage: null,
      ),
    );
    await _loadProducts();
  }

  Future<void> clearSelectedCategory() async {
    emit(
      state.copyWith(
        selectedCategoryId: null,
        selectedSubcategoryId: null,
        selectedUnitId: null,
        selectedPackageTypeId: null,
        selectedMeasurementUnitId: null,
        selectedMeasurementValue: null,
        selectedSortValue: '',
        priceRange: state.priceBounds,
        errorMessage: null,
      ),
    );
    await _loadProducts();
  }

  Future<void> clearAllFilters() async {
    emit(
      state.copyWith(
        selectedCategoryId: null,
        selectedSubcategoryId: null,
        selectedUnitId: null,
        selectedPackageTypeId: null,
        selectedMeasurementUnitId: null,
        selectedMeasurementValue: null,
        selectedSortValue: '',
        priceRange: state.priceBounds,
        errorMessage: null,
      ),
    );
    await _loadProducts();
  }

  Future<void> applyFilters({
    String? categoryName,
    String? subcategoryName,
    String? unitName,
    String? packageTypeId,
    String? measurementUnitId,
    double? measurementValue,
    RangeValues? priceRange,
  }) async {
    emit(
      state.copyWith(
        selectedCategoryId: _findOptionIdByName(state.categories, categoryName),
        selectedSubcategoryId: _findSubcategoryIdByName(subcategoryName),
        selectedUnitId: _findOptionIdByName(state.units, unitName),
        selectedPackageTypeId: packageTypeId,
        selectedMeasurementUnitId: measurementUnitId,
        selectedMeasurementValue: measurementValue,
        priceRange: priceRange ?? state.priceBounds,
        errorMessage: null,
      ),
    );
    await _loadProducts();
  }

  Future<void> applySortOption(String? sortOption) async {
    emit(
      state.copyWith(
        selectedSortValue: sortOption ?? '',
        errorMessage: null,
      ),
    );
    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        exception: null,
        currentPage: 1,
        hasMore: true,
      ),
    );

    final result = await _getBrandProductsUseCase(
      _buildRequest(page: 1),
    );
    switch (result) {
      case ApiSuccessResult<BrandProductsEntity>():
        final data = result.data;
        final hasMore = data.items.length < data.total;
        emit(
          state.copyWith(
            isLoading: false,
            products: data.items,
            totalProducts: data.total,
            currentPage: 1,
            hasMore: hasMore,
            errorMessage: null,
            exception: null,
          ),
        );
      case ApiErrorResult<BrandProductsEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            products: const [],
            totalProducts: 0,
            hasMore: false,
            errorMessage: result.failure.errorMessage,
            exception: result.failure.exception,
          ),
        );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    final nextPage = state.currentPage + 1;
    emit(state.copyWith(isLoadingMore: true));

    final result = await _getBrandProductsUseCase(
      _buildRequest(page: nextPage),
    );
    switch (result) {
      case ApiSuccessResult<BrandProductsEntity>():
        final data = result.data;
        final allProducts = [...state.products, ...data.items];
        final hasMore = allProducts.length < data.total;
        emit(
          state.copyWith(
            isLoadingMore: false,
            products: allProducts,
            totalProducts: data.total,
            currentPage: nextPage,
            hasMore: hasMore,
          ),
        );
      case ApiErrorResult<BrandProductsEntity>():
        emit(state.copyWith(isLoadingMore: false));
    }
  }

  BrandProductsRequestEntity _buildRequest({int page = 1}) {
    final hasActivePriceFilter = state.hasActivePriceFilter;

    return BrandProductsRequestEntity(
      brandId: _brand.id,
      brandName: _brand.name,
      brandEmoji: _brand.emoji,
      categoryId: state.selectedCategoryId,
      subcategoryId: state.selectedSubcategoryId,
      unitId: state.selectedUnitId,
      packageTypeId: state.selectedPackageTypeId,
      measurementUnitId: state.selectedMeasurementUnitId,
      measurementValue: state.selectedMeasurementValue,
      minPrice: hasActivePriceFilter ? state.priceRange.start : null,
      maxPrice: hasActivePriceFilter ? state.priceRange.end : null,
      sort: state.selectedSortValue.isEmpty ? null : state.selectedSortValue,
      page: page,
      perPage: _perPage,
    );
  }

  String? _findOptionIdByName(
    List<BrandFilterOptionEntity> items,
    String? name,
  ) {
    if (name == null || name.isEmpty) {
      return null;
    }

    for (final item in items) {
      if (item.name == name) {
        return item.id;
      }
    }
    return null;
  }

  String? _findSubcategoryIdByName(String? name) {
    if (name == null || name.isEmpty) {
      return null;
    }

    for (final item in state.subcategories) {
      if (item.name == name) {
        return item.id;
      }
    }
    return null;
  }
}
