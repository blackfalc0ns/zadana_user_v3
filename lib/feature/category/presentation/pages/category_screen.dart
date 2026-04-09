import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/feature/category/data/mapper/category_products_mapper.dart';
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
  static const List<Map<String, dynamic>> _sortOptions = [
    {
      'value': 'newest',
      'title': 'الأحدث',
      'subtitle': 'أحدث المنتجات المضافة',
    },
    {
      'value': 'price_low_high',
      'title': 'السعر من الأقل للأعلى',
      'subtitle': 'ترتيب تصاعدي حسب السعر',
    },
    {
      'value': 'price_high_low',
      'title': 'السعر من الأعلى للأقل',
      'subtitle': 'ترتيب تنازلي حسب السعر',
    },
    {
      'value': 'best_selling',
      'title': 'الأكثر مبيعًا',
      'subtitle': 'المنتجات الأعلى طلبًا',
    },
    {
      'value': 'alphabetical',
      'title': 'أبجديًا',
      'subtitle': 'ترتيب حسب الاسم',
    },
  ];

  final List<String> _selectedFilters = [];
  late final CategoryNavigationService _navigationService;

  List<CategoryEntity> _categories = const [];
  List<ProductModel> _products = const [];
  List<CategorySubcategoryItemDto> _subCategories = const [];

  String _selectedCategory = '';
  String _selectedSortOption = '';
  String? _selectedCategoryId;
  String? _selectedSubCategory;
  String? _selectedSubCategoryId;
  String? _filterSelectedCategory;
  String? _filterSelectedQuantity;
  String? _filterSelectedBrand;
  bool _isCategoryPreselectedFromOutside = false;
  bool _isLoading = true;
  bool _isSubCategoriesLoading = false;
  String? _activeHeroProductId;
  String? _errorMessage;
  RangeValues _priceRange = const RangeValues(0, 1000);

  List<String> get _availableBrands {
    final values = _products
        .map((product) => product.store.trim())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return values;
  }

  List<String> get _availableQuantities {
    final values = _products
        .map((product) => product.unit?.trim() ?? '')
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return values;
  }

  @override
  void initState() {
    super.initState();
    _navigationService = CategoryNavigationService()
      ..addListener(_checkSelectedCategory);
    unawaited(_loadInitialData());
  }

  @override
  void dispose() {
    _navigationService.removeListener(_checkSelectedCategory);
    super.dispose();
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
      _filterSelectedCategory = category.name;
      _filterSelectedQuantity = null;
      _filterSelectedBrand = null;
      _priceRange = const RangeValues(0, 1000);
      _isCategoryPreselectedFromOutside = fromOutside;
      _isLoading = true;
      _isSubCategoriesLoading = true;
      _errorMessage = null;
    });

    try {
      final subCategories = await getIt<ApiServices>().getCategorySubcategories(
        category.id,
      );

      if (!mounted) return;

      setState(() {
        _subCategories = subCategories
            .where(
              (item) =>
                  (item.id ?? '').isNotEmpty &&
                  (item.name ?? '').trim().isNotEmpty,
            )
            .toList();
        _isSubCategoriesLoading = false;
      });

      await _loadCategoryProducts();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _subCategories = const [];
        _products = const [];
        _selectedSubCategory = null;
        _selectedSubCategoryId = null;
        _isLoading = false;
        _isSubCategoriesLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _loadCategoryProducts({String? requestedId}) async {
    final targetId = requestedId ?? _selectedCategoryId;
    if (targetId == null || targetId.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await getIt<ApiServices>().getCategoryProducts(targetId);
      final products = (response.items ?? const [])
          .map((item) => item.toEntity())
          .toList();

      if (!mounted) return;

      setState(() {
        _products = products;
        _isLoading = false;
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
      selectedQuantity: _filterSelectedQuantity,
      filterSelectedCategory: _filterSelectedCategory,
      filterSelectedQuantity: _filterSelectedQuantity,
      filterSelectedBrand: _filterSelectedBrand,
      priceRange: _priceRange,
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

        if (isSameSubCategory) {
          unawaited(_loadCategoryProducts());
          return;
        }

        unawaited(_loadCategoryProducts(requestedId: subCategory.id));
      },
      onFilterApplied: _onFilterApplied,
      onSortChanged: (result) {
        if (result != null) {
          setState(() => _selectedSortOption = result);
        }
      },
      onFilterChanged: (result) {
        if (result == null) return;

        final categoryName = result['category'] as String?;
        if (categoryName != null && categoryName != _selectedCategory) {
          _onFilterApplied(result);
          return;
        }

        setState(() {
          _filterSelectedCategory = categoryName ?? _filterSelectedCategory;
          _filterSelectedQuantity = result['quantity'] as String?;
          _filterSelectedBrand = result['brand'] as String?;
          _priceRange = result['priceRange'] as RangeValues? ??
              const RangeValues(0, 1000);
        });
      },
      onClearAllFilters: () => setState(() {
        _filterSelectedCategory = _isCategoryPreselectedFromOutside
            ? _selectedCategory
            : null;
        _filterSelectedQuantity = null;
        _filterSelectedBrand = null;
        _priceRange = const RangeValues(0, 1000);
      }),
      sortOptions: _sortOptions,
      hasActiveFilters:
          _selectedFilters.isNotEmpty ||
          _selectedSortOption.isNotEmpty ||
          _filterSelectedCategory != null ||
          _filterSelectedQuantity != null ||
          _filterSelectedBrand != null ||
          _priceRange.start != 0 ||
          _priceRange.end != 1000,
      bottomNavHeight: 60,
      activeHeroProductId: _activeHeroProductId,
      onProductTap: _openProductDetails,
    );
  }
}

extension _FirstWhereOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
