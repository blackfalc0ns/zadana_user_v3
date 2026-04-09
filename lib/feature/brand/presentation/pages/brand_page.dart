import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/widgets/custom_bottom_filter_buttons.dart';
import 'package:zadana_user_v3/core/widgets/custom_sort_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/brand/data/mapper/brand_products_mapper.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';
import 'package:zadana_user_v3/feature/brand/domain/enums/product_sort_option.dart';
import 'package:zadana_user_v3/feature/brand/presentation/logic/brand_filter_logic.dart';
import 'package:zadana_user_v3/feature/brand/presentation/services/brand_filter_service.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/brand_header.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/brand_products_grid.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/brand_search_bar.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/filter_chip_row.dart';

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
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBrandProducts();
  }

  Future<void> _loadBrandProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiServices = getIt<ApiServices>();
      final response = await apiServices.getBrandProducts(widget.brand.id);
      final products = response.toEntities(widget.brand);

      if (!mounted) return;

      _allProducts = products;
      _categories = BrandFilterLogic.extractCategories(_allProducts);
      _units = BrandFilterLogic.extractUnits(_allProducts);
      _applyFilters(shouldSetState: false);

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
        _allProducts = [];
        _filteredProducts = [];
        _categories = [];
        _units = [];
      });
    }
  }

  void _applyFilters({bool shouldSetState = true}) {
    var filtered = _allProducts.where((product) {
      if (_selectedCategory != null && product.category != _selectedCategory) {
        return false;
      }

      if (_selectedSubcategory != null &&
          product.subcategory != _selectedSubcategory) {
        return false;
      }

      if (product.price < _priceRange.start || product.price > _priceRange.end) {
        return false;
      }

      if (_selectedUnit != null && product.unit != _selectedUnit) {
        return false;
      }

      return true;
    }).toList();

    filtered = BrandFilterLogic.sortProducts(filtered, _currentSort);

    if (shouldSetState) {
      setState(() => _filteredProducts = filtered);
    } else {
      _filteredProducts = filtered;
    }
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
          if (_isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_errorMessage != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadBrandProducts,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            BrandProductsGrid(products: _filteredProducts),
        ],
      ),
      floatingActionButton: _isLoading || _errorMessage != null
          ? null
          : CustomBottomFilterButtons(
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
