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

  final BrandModel _brand;
  final GetBrandFiltersUseCase _getBrandFiltersUseCase;
  final GetBrandProductsUseCase _getBrandProductsUseCase;

  Future<void> loadInitial() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

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
            sortOptions: filters.sortOptions,
            priceBounds: priceBounds,
            priceRange: priceBounds,
            errorMessage: null,
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
            sortOptions: const [],
            errorMessage: result.failure.errorMessage,
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
        errorMessage: null,
      ),
    );
    await _loadProducts();
  }

  Future<void> applyFilters({
    String? categoryName,
    String? subcategoryName,
    String? unitName,
    RangeValues? priceRange,
  }) async {
    emit(
      state.copyWith(
        selectedCategoryId: _findOptionIdByName(state.categories, categoryName),
        selectedSubcategoryId: _findSubcategoryIdByName(subcategoryName),
        selectedUnitId: _findOptionIdByName(state.units, unitName),
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
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getBrandProductsUseCase(_buildRequest());
    switch (result) {
      case ApiSuccessResult<BrandProductsEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            products: result.data.items,
            errorMessage: null,
          ),
        );
      case ApiErrorResult<BrandProductsEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            products: const [],
            errorMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  BrandProductsRequestEntity _buildRequest() {
    final hasActivePriceFilter = state.hasActivePriceFilter;

    return BrandProductsRequestEntity(
      brandId: _brand.id,
      brandName: _brand.name,
      brandEmoji: _brand.emoji,
      categoryId: state.selectedCategoryId,
      subcategoryId: state.selectedSubcategoryId,
      unitId: state.selectedUnitId,
      minPrice: hasActivePriceFilter ? state.priceRange.start : null,
      maxPrice: hasActivePriceFilter ? state.priceRange.end : null,
      sort: state.selectedSortValue.isEmpty ? null : state.selectedSortValue,
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
