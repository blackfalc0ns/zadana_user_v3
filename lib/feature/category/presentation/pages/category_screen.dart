import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/core/services/favorite_sync_service.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/feature/category/data/mapper/category_products_mapper.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_brand_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_part_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/reusable_category_screen.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<String> _selectedFilters = [];
  late final CategoryNavigationService _navigationService;
  late final FavoriteSyncService _favoriteSyncService;

  List<CategoryEntity> _categories = const [];
  List<ProductModel> _products = const [];
  List<CategorySubcategoryItemDto> _subCategories = const [];
  List<CategoryFilterOptionDto> _quantityOptions = const [];
  List<CategoryFilterBrandItemDto> _brandOptions = const [];
  List<CategoryFilterOptionDto> _productTypeOptions = const [];
  List<CategoryFilterPartItemDto> _partOptions = const [];
  List<Map<String, dynamic>> _sortOptions = const [];

  String _selectedCategory = '';
  String _selectedSortOption = '';
  String? _selectedCategoryId;
  String? _selectedSubCategory;
  String? _selectedSubCategoryId;
  String? _filterSelectedCategory;
  String? _filterSelectedQuantity;
  String? _filterSelectedBrand;
  String? _filterSelectedProductType;
  String? _filterSelectedPart;
  String? _selectedQuantityId;
  String? _selectedBrandId;
  String? _selectedProductTypeId;
  String? _selectedPartId;
  bool _isCategoryPreselectedFromOutside = false;
  bool _isLoading = true;
  bool _isSubCategoriesLoading = false;
  String? _activeHeroProductId;
  String? _errorMessage;
  RangeValues _priceRange = const RangeValues(0, 1000);
  RangeValues _priceBounds = const RangeValues(0, 1000);

  List<String> get _availableBrands => _brandOptions
      .map((item) => item.name?.trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList();

  List<String> get _availableQuantities => _quantityOptions
      .map((item) => item.name?.trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList();

  List<String> get _availableProductTypes => _productTypeOptions
      .map((item) => item.name?.trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList();

  List<String> get _availableParts {
    final selectedProductTypeId = _selectedProductTypeId;
    return _partOptions
        .where(
          (item) =>
              selectedProductTypeId == null ||
              selectedProductTypeId.isEmpty ||
              item.productTypeId == selectedProductTypeId,
        )
        .map((item) => item.name?.trim() ?? '')
        .where((item) => item.isNotEmpty)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _favoriteSyncService = FavoriteSyncService()
      ..addListener(_syncFavoriteState);
    _navigationService = CategoryNavigationService()
      ..addListener(_checkSelectedCategory);
    unawaited(_loadInitialData());
  }

  @override
  void dispose() {
    _favoriteSyncService.removeListener(_syncFavoriteState);
    _navigationService.removeListener(_checkSelectedCategory);
    super.dispose();
  }

  void _syncFavoriteState() {
    final productId = _favoriteSyncService.productId;
    final isFavorite = _favoriteSyncService.isFavorite;

    if (!mounted || productId == null || isFavorite == null) return;

    setState(() {
      _products = _products
          .map(
            (product) => product.id == productId
                ? product.copyWith(isFavorite: isFavorite)
                : product,
          )
          .toList();
    });
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await getIt<ApiServices>().getHomeCategories();
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

      if (!mounted) return;

      setState(() {
        _categories = categories;
      });

      final selectedFromHome = _navigationService.selectedCategory;
      final initialCategory = _resolveRequestedCategory(selectedFromHome) ??
          (categories.isNotEmpty ? categories.first : null);

      if (initialCategory == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'لا توجد أقسام متاحة حاليًا';
        });
        return;
      }

      await _selectCategory(
        initialCategory,
        fromOutside: selectedFromHome != null,
      );

      if (selectedFromHome != null) {
        _navigationService.clearSelectedCategory();
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  CategoryEntity? _resolveRequestedCategory(CategoryEntity? requested) {
    if (requested == null) return null;

    for (final category in _categories) {
      if (category.id == requested.id || category.name == requested.name) {
        return category;
      }
    }

    return null;
  }

  void _checkSelectedCategory() {
    final requested = _resolveRequestedCategory(
      _navigationService.selectedCategory,
    );
    if (requested == null) return;

    unawaited(_selectCategory(requested, fromOutside: true));
    _navigationService.clearSelectedCategory();
  }

  Future<void> _selectCategory(
    CategoryEntity category, {
    bool fromOutside = false,
  }) async {
    setState(() {
      _selectedCategory = category.name;
      _selectedCategoryId = category.id;
      _selectedSubCategory = null;
      _selectedSubCategoryId = null;
      _subCategories = const [];
      _products = const [];
      _quantityOptions = const [];
      _brandOptions = const [];
      _productTypeOptions = const [];
      _partOptions = const [];
      _sortOptions = const [];
      _filterSelectedCategory = category.name;
      _filterSelectedQuantity = null;
      _filterSelectedBrand = null;
      _filterSelectedProductType = null;
      _filterSelectedPart = null;
      _selectedQuantityId = null;
      _selectedBrandId = null;
      _selectedProductTypeId = null;
      _selectedPartId = null;
      _priceBounds = const RangeValues(0, 1000);
      _priceRange = _priceBounds;
      _isCategoryPreselectedFromOutside = fromOutside;
      _isLoading = true;
      _isSubCategoriesLoading = true;
      _errorMessage = null;
    });

    try {
      final filters = await getIt<ApiServices>().getCategoryFilters(category.id);
      if (!mounted) return;

      _applyCategoryFilters(filters);
      await _loadCategoryProducts();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _subCategories = const [];
        _products = const [];
        _quantityOptions = const [];
        _brandOptions = const [];
        _productTypeOptions = const [];
        _partOptions = const [];
        _sortOptions = const [];
        _selectedSubCategory = null;
        _selectedSubCategoryId = null;
        _isLoading = false;
        _isSubCategoriesLoading = false;
        _errorMessage = error.toString();
      });
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

    setState(() {
      _subCategories = subCategories;
      _quantityOptions = quantityOptions;
      _brandOptions = brandOptions;
      _productTypeOptions = productTypeOptions;
      _partOptions = partOptions;
      _sortOptions = (filters.sortOptions ?? const [])
          .map(
            (item) => {
              'value': item.value ?? '',
              'title': item.label ?? '',
              'subtitle': null,
            },
          )
          .where((item) => (item['value'] as String).isNotEmpty)
          .toList();
      _priceBounds = priceBounds;
      _priceRange = priceBounds;
      _isSubCategoriesLoading = false;
    });
  }

  Future<void> _loadCategoryProducts() async {
    final targetId = _selectedCategoryId;
    if (targetId == null || targetId.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await getIt<ApiServices>().getCategoryProducts(
        targetId,
        _selectedSubCategoryId,
        _selectedProductTypeId,
        _selectedPartId,
        _selectedQuantityId,
        _selectedBrandId,
        _priceRange.start,
        _priceRange.end,
        _selectedSortOption.isEmpty ? null : _selectedSortOption,
      );
      final products = (response.items ?? const [])
          .map((item) => item.toEntity())
          .toList();

      if (!mounted) return;

      setState(() {
        _products = products;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _products = const [];
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _openProductDetails(ProductModel product) async {
    setState(() => _activeHeroProductId = product.id);
    await WidgetsBinding.instance.endOfFrame;

    if (!mounted) return;

    await ProductNavigationHelper.navigateToProductDetails(
      context,
      product,
      heroTag: productHeroTag(product.id, source: 'category-grid'),
    );

    if (!mounted) return;
    setState(() => _activeHeroProductId = null);
  }

  void _onCategorySelected(String categoryName) {
    if (categoryName == _selectedCategory) return;

    final category = _categories
        .where((item) => item.name == categoryName)
        .firstOrNull;
    if (category == null) return;

    unawaited(_selectCategory(category));
  }

  void _onFilterApplied(Map<String, dynamic> data) {
    final categoryName = data['category'] as String?;
    if (categoryName == null || categoryName == _selectedCategory) {
      return;
    }

    final category = _categories
        .where((item) => item.name == categoryName)
        .firstOrNull;
    if (category == null) return;

    unawaited(_selectCategory(category));
  }

  String? _findOptionId(
    List<CategoryFilterOptionDto> options,
    String? selectedName,
  ) {
    if (selectedName == null || selectedName.isEmpty) return null;
    return options
        .where((item) => item.name == selectedName)
        .map((item) => item.id)
        .firstOrNull;
  }

  String? _findBrandId(String? selectedName) {
    if (selectedName == null || selectedName.isEmpty) return null;
    return _brandOptions
        .where((item) => item.name == selectedName)
        .map((item) => item.id)
        .firstOrNull;
  }

  String? _findPartId(String? selectedName) {
    if (selectedName == null || selectedName.isEmpty) return null;
    return _partOptions
        .where((item) => item.name == selectedName)
        .map((item) => item.id)
        .firstOrNull;
  }

  bool get _hasActivePriceFilter =>
      _priceRange.start != _priceBounds.start ||
      _priceRange.end != _priceBounds.end;

  bool get _hasActiveCategoryFilter =>
      !_isCategoryPreselectedFromOutside &&
      _filterSelectedCategory != null &&
      _filterSelectedCategory != _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return ReusableCategoryScreen(
      categories: _categories,
      selectedCategory: _selectedCategory,
      selectedSubCategory: _selectedSubCategory ?? '',
      selectedSubCategoryId: _selectedSubCategoryId,
      selectedSortOption: _selectedSortOption,
      selectedFilters: _selectedFilters,
      products: _products,
      availableBrands: _availableBrands,
      availableQuantities: _availableQuantities,
      availableProductTypes: _availableProductTypes,
      availableParts: _availableParts,
      selectedQuantity: _filterSelectedQuantity,
      selectedProductType: _filterSelectedProductType,
      selectedPart: _filterSelectedPart,
      filterSelectedCategory: _filterSelectedCategory,
      filterSelectedQuantity: _filterSelectedQuantity,
      filterSelectedBrand: _filterSelectedBrand,
      priceRange: _priceRange,
      priceBounds: _priceBounds,
      showCategoryFilterSection: !_isCategoryPreselectedFromOutside,
      isLoading: _isLoading,
      subCategories: _subCategories,
      isSubCategoriesLoading: _isSubCategoriesLoading,
      emptyStateMessage: _errorMessage,
      onCategorySelected: _onCategorySelected,
      onSubCategorySelected: (subCategory) {
        final isSameSubCategory = _selectedSubCategoryId == subCategory.id;

        setState(() {
          _selectedSubCategoryId = isSameSubCategory ? null : subCategory.id;
          _selectedSubCategory = isSameSubCategory ? null : subCategory.name;
        });

        unawaited(_loadCategoryProducts());
      },
      onFilterApplied: _onFilterApplied,
      onSortChanged: (result) {
        setState(() {
          _selectedSortOption = result ?? '';
        });
        unawaited(_loadCategoryProducts());
      },
      onFilterChanged: (result) {
        if (result == null) return;

        final categoryName = result['category'] as String?;
        if (categoryName != null && categoryName != _selectedCategory) {
          _onFilterApplied(result);
          return;
        }

        final quantity = result['quantity'] as String?;
        final brand = result['brand'] as String?;
        final productType = result['productType'] as String?;
        final part = result['part'] as String?;
        final priceRange = result['priceRange'] as RangeValues? ?? _priceBounds;

        setState(() {
          _filterSelectedCategory = categoryName ?? _filterSelectedCategory;
          _filterSelectedQuantity = quantity;
          _filterSelectedBrand = brand;
          _filterSelectedProductType = productType;
          _filterSelectedPart = part;
          _selectedQuantityId = _findOptionId(_quantityOptions, quantity);
          _selectedBrandId = _findBrandId(brand);
          _selectedProductTypeId = _findOptionId(
            _productTypeOptions,
            productType,
          );
          _selectedPartId = _findPartId(part);
          _priceRange = priceRange;
        });

        unawaited(_loadCategoryProducts());
      },
      onClearAllFilters: () {
        setState(() {
          _filterSelectedCategory = _isCategoryPreselectedFromOutside
              ? _selectedCategory
              : null;
          _filterSelectedQuantity = null;
          _filterSelectedBrand = null;
          _filterSelectedProductType = null;
          _filterSelectedPart = null;
          _selectedQuantityId = null;
          _selectedBrandId = null;
          _selectedProductTypeId = null;
          _selectedPartId = null;
          _priceRange = _priceBounds;
        });
        unawaited(_loadCategoryProducts());
      },
      sortOptions: _sortOptions,
      hasActiveFilters:
          _selectedFilters.isNotEmpty ||
          _selectedSortOption.isNotEmpty ||
          _hasActiveCategoryFilter ||
          _filterSelectedQuantity != null ||
          _filterSelectedBrand != null ||
          _filterSelectedProductType != null ||
          _filterSelectedPart != null ||
          _selectedSubCategoryId != null ||
          _hasActivePriceFilter,
      bottomNavHeight: 60,
      activeHeroProductId: _activeHeroProductId,
      onProductTap: _openProductDetails,
    );
  }
}

extension _FirstWhereOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
