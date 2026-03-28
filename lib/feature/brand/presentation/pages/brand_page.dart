import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/widgets/custom_bottom_filter_buttons.dart';
import 'package:zadana_user_v3/core/widgets/custom_sort_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';
import 'package:zadana_user_v3/feature/brand/domain/enums/product_sort_option.dart';
import 'package:zadana_user_v3/feature/brand/data/mock_brand_products.dart';
import 'package:zadana_user_v3/feature/brand/presentation/logic/brand_filter_logic.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/brand_header.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/brand_search_bar.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/filter_chip_row.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/brand_products_grid.dart';
import 'package:zadana_user_v3/feature/brand/presentation/services/brand_filter_service.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key, required this.brand});
  final BrandModel brand;
  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  ProductSortOption _currentSort = ProductSortOption.bestSellers;
  String? _selectedCategory;
  String? _selectedSubcategory;
  String? _selectedUnit;
  RangeValues _priceRange = const RangeValues(0, 500);
  List<BrandProductModel> _allProducts = [];
  List<BrandProductModel> _filteredProducts = [];
  List<String> _categories = [];
  List<String> _units = [];

  @override
  void initState() {
    super.initState();
    _allProducts = MockBrandProducts.getProducts(
      widget.brand.id,
      widget.brand.name,
    );
    _categories = BrandFilterLogic.extractCategories(_allProducts);
    _units = BrandFilterLogic.extractUnits(_allProducts);
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = _allProducts.where((product) {
      // Category filter
      if (_selectedCategory != null && product.category != _selectedCategory) {
        return false;
      }

      // Subcategory filter
      if (_selectedSubcategory != null &&
          product.subcategory != _selectedSubcategory) {
        return false;
      }

      // Price range filter
      if (product.price < _priceRange.start || product.price > _priceRange.end) {
        return false;
      }

      // Unit filter
      if (_selectedUnit != null && product.unit != _selectedUnit) return false;

      return true;
    }).toList();

    filtered = BrandFilterLogic.sortProducts(filtered, _currentSort);
    setState(() => _filteredProducts = filtered);
  }

  void _showFilterBottomSheet() async {
    final result = await BrandFilterService.showFilterBottomSheet(
      context: context,
      allProducts: _allProducts,
      categories: _categories,
      units: _units,
      currentPriceRange: _priceRange,
      currentSelectedCategory: _selectedCategory,
      currentSelectedSubcategory: _selectedSubcategory,
      currentSelectedUnit: _selectedUnit,
    );

    if (result != null) {
      setState(() {
        _selectedCategory = result['category'];
        _selectedSubcategory = result['subcategory'];
        _priceRange = result['priceRange'] ?? const RangeValues(0, 500);
        _selectedUnit = result['unit'];
      });
      _applyFilters();
    }
  }

  void _showSortBottomSheet() {
    final sortOptions = [
      {
        'value': 'bestSellers',
        'title': 'الأكثر مبيعاً',
        'subtitle': 'المنتجات الأكثر شراءً',
      },
      {
        'value': 'priceLowToHigh',
        'title': 'السعر من الأقل للأعلى',
        'subtitle': 'ترتيب تصاعدي حسب السعر',
      },
      {
        'value': 'priceHighToLow',
        'title': 'السعر من الأعلى للأقل',
        'subtitle': 'ترتيب تنازلي حسب السعر',
      },
      {
        'value': 'newest',
        'title': 'الأحدث',
        'subtitle': 'المنتجات المضافة حديثاً',
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CustomSortBottomSheet(
        selectedSortOption: _currentSort.name,
        sortOptions: sortOptions,
        title: 'ترتيب المنتجات',
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          switch (result) {
            case 'bestSellers':
              _currentSort = ProductSortOption.bestSellers;
              break;
            case 'priceLowToHigh':
              _currentSort = ProductSortOption.priceLowToHigh;
              break;
            case 'priceHighToLow':
              _currentSort = ProductSortOption.priceHighToLow;
              break;
            case 'newest':
              _currentSort = ProductSortOption.newest;
              break;
          }
        });
        _applyFilters();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          BrandHeader(brand: widget.brand),
          SliverPersistentHeader(
            pinned: true,
            delegate: BrandSearchBarDelegate(
              brandName: widget.brand.name,
              onFilterPressed: _showFilterBottomSheet,
            ),
          ),
          if (_categories.isNotEmpty)
            SliverToBoxAdapter(
              child: FilterChipRow(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() => _selectedCategory = category);
                  _applyFilters();
                },
              ),
            ),
          BrandProductsGrid(products: _filteredProducts),
        ],
      ),
      floatingActionButton: CustomBottomFilterButtons(
        sortLabel: 'ترتيب',
        filterLabel: 'تصنيف',
        onSortPressed: _showSortBottomSheet,
        onFilterPressed: _showFilterBottomSheet,
        hasActiveFilters:
            _selectedCategory != null ||
            _selectedSubcategory != null ||
            _selectedUnit != null ||
            _priceRange.start != 0 ||
            _priceRange.end != 500 ||
            _currentSort != ProductSortOption.bestSellers,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
