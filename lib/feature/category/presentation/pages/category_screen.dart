import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/reusable_category_screen.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _selectedCategory = 'خضروات';
  String _selectedSubCategory = '';
  String _selectedSortOption = '';
  final List<String> _selectedFilters = [];
  late CategoryNavigationService _navigationService;
  bool _isCategoryPreselectedFromOutside = false;
  String? _activeHeroProductId;

  String? _filterSelectedCategory;
  String? _filterSelectedProductType;
  String? _filterSelectedPart;
  String? _filterSelectedQuantity;
  String? _filterSelectedBrand;
  RangeValues _priceRange = const RangeValues(0, 1000);

  @override
  void initState() {
    super.initState();
    _navigationService = CategoryNavigationService()
      ..addListener(_checkSelectedCategory);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkSelectedCategory());
  }

  @override
  void dispose() {
    _navigationService.removeListener(_checkSelectedCategory);
    super.dispose();
  }

  void _checkSelectedCategory() {
    final categoryName = _navigationService.getCategoryNameForScreen();
    if (categoryName != null &&
        kCategorySubCategories.containsKey(categoryName) &&
        mounted) {
      setState(() {
        _selectedCategory = categoryName;
        _selectedSubCategory = '';
        _filterSelectedCategory = categoryName;
        _filterSelectedProductType = null;
        _filterSelectedPart = null;
        _filterSelectedQuantity = null;
        _filterSelectedBrand = null;
        _isCategoryPreselectedFromOutside = true;
      });
      _navigationService.clearSelectedCategory();
    }
  }

  Future<void> _openProductDetails(ProductModel product) async {
    setState(() => _activeHeroProductId = product.id);
    await WidgetsBinding.instance.endOfFrame;

    if (!mounted) return;

    await ProductNavigationHelper.navigateToProductDetails(context, product);

    if (!mounted) return;
    setState(() => _activeHeroProductId = null);
  }

  @override
  Widget build(BuildContext context) {
    return ReusableCategoryScreen(
      selectedCategory: _selectedCategory,
      selectedSubCategory: _selectedSubCategory,
      selectedSortOption: _selectedSortOption,
      selectedFilters: _selectedFilters,
      selectedQuantity: _filterSelectedQuantity,
      filterSelectedCategory: _filterSelectedCategory,
      filterSelectedProductType: _filterSelectedProductType,
      filterSelectedPart: _filterSelectedPart,
      filterSelectedQuantity: _filterSelectedQuantity,
      filterSelectedBrand: _filterSelectedBrand,
      priceRange: _priceRange,
      showCategoryFilterSection: !_isCategoryPreselectedFromOutside,
      onCategorySelected: (category) {
        setState(() {
          _isCategoryPreselectedFromOutside = false;
          _selectedCategory = category;
          _selectedSubCategory = '';
          _filterSelectedCategory = category;
          _filterSelectedProductType = null;
          _filterSelectedPart = null;
          _filterSelectedQuantity = null;
          _filterSelectedBrand = null;
        });
      },
      onFilterApplied: (data) {
        if (data['category'] != null) {
          setState(() {
            _selectedCategory = data['category'];
            _filterSelectedCategory = data['category'];
            _filterSelectedProductType = null;
            _filterSelectedPart = null;
            _filterSelectedQuantity = null;
            _filterSelectedBrand = null;
          });
        }
      },
      onSortChanged: (result) {
        if (result != null) {
          setState(() => _selectedSortOption = result);
        }
      },
      onFilterChanged: (result) {
        if (result != null) {
          setState(() {
            _filterSelectedCategory = _isCategoryPreselectedFromOutside
                ? _selectedCategory
                : result['category'];
            _filterSelectedProductType = result['productType'];
            _filterSelectedPart = result['part'];
            _filterSelectedQuantity = result['quantity'];
            _filterSelectedBrand = result['brand'];
            _priceRange = result['priceRange'] ?? const RangeValues(0, 1000);

            if (_filterSelectedCategory != null) {
              _selectedCategory = _filterSelectedCategory!;
              _selectedSubCategory = '';
            }
          });
        }
      },
      onClearAllFilters: () => setState(() {
        _filterSelectedCategory = _isCategoryPreselectedFromOutside
            ? _selectedCategory
            : null;
        _filterSelectedProductType = null;
        _filterSelectedPart = null;
        _filterSelectedQuantity = null;
        _filterSelectedBrand = null;
        _priceRange = const RangeValues(0, 1000);
      }),
      sortOptions: kSortOptions.map((option) => option['value'] as String).toList(),
      hasActiveFilters: _selectedFilters.isNotEmpty ||
          _selectedSortOption.isNotEmpty ||
          _filterSelectedCategory != null ||
          _filterSelectedProductType != null ||
          _filterSelectedPart != null ||
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
