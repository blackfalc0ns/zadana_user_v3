import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/widgets/custom_bottom_filter_buttons.dart';
import 'package:zadana_user_v3/core/widgets/custom_sort_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/brand/data/mapper/brand_products_mapper.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_filter_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';
import 'package:zadana_user_v3/feature/brand/presentation/services/brand_filter_service.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/brand_header.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/brand_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/brand_products_grid.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/brand_search_bar.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/filter_chip_row.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_params.dart';
import 'package:zadana_user_v3/feature/search/presentation/pages/product_search_page.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key, required this.brand});

  final BrandModel brand;

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  String _selectedSortOption = '';
  String? _selectedCategory;
  String? _selectedSubcategory;
  String? _selectedUnit;
  String? _selectedCategoryId;
  String? _selectedSubcategoryId;
  String? _selectedUnitId;
  RangeValues _priceRange = const RangeValues(0, 500);
  RangeValues _priceBounds = const RangeValues(0, 500);
  List<BrandProductModel> _products = [];
  List<BrandFilterOptionDto> _categories = const [];
  List<BrandFilterSubcategoryItemDto> _subcategories = const [];
  List<BrandFilterOptionDto> _units = const [];
  List<Map<String, dynamic>> _sortOptions = const [];
  bool _isLoading = true;
  String? _errorMessage;

  List<String> get _categoryNames => _categories
      .map((item) => item.name?.trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList();

  List<String> get _unitNames => _units
      .map((item) => item.name?.trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList();

  @override
  void initState() {
    super.initState();
    _loadBrandData();
  }

  Future<void> _loadBrandData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiServices = getIt<ApiServices>();
      final filters = await apiServices.getBrandFilters(widget.brand.id);
      final minPrice = filters.priceRange?.min ?? 0;
      final maxPrice = filters.priceRange?.max ?? minPrice;
      final priceBounds = RangeValues(minPrice, maxPrice >= minPrice ? maxPrice : minPrice);

      if (!mounted) return;

      setState(() {
        _categories = (filters.categories ?? const [])
            .where((item) => (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty)
            .toList();
        _subcategories = (filters.subcategories ?? const [])
            .where((item) => (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty)
            .toList();
        _units = (filters.units ?? const [])
            .where((item) => (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty)
            .toList();
        _sortOptions = (filters.sortOptions ?? const [])
            .map((item) => {
                  'value': item.value ?? '',
                  'title': item.label ?? '',
                  'subtitle': null,
                })
            .where((item) => (item['value'] as String).isNotEmpty)
            .toList();
        _priceBounds = priceBounds;
        _priceRange = priceBounds;
      });

      await _loadBrandProducts();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
        _products = [];
        _categories = const [];
        _subcategories = const [];
        _units = const [];
        _sortOptions = const [];
      });
    }
  }

  Future<void> _loadBrandProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiServices = getIt<ApiServices>();
      final response = await apiServices.getBrandProducts(
        widget.brand.id,
        _selectedCategoryId,
        _selectedSubcategoryId,
        _selectedUnitId,
        _priceRange.start,
        _priceRange.end,
        _selectedSortOption.isEmpty ? null : _selectedSortOption,
      );
      final products = response.toEntities(widget.brand);

      if (!mounted) return;

      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
        _products = [];
      });
    }
  }

  String? _findCategoryId(String? name) {
    if (name == null || name.isEmpty) return null;
    return _categories
        .firstWhere(
          (item) => item.name == name,
          orElse: () => const BrandFilterOptionDto(),
        )
        .id;
  }

  String? _findSubcategoryId(String? name) {
    if (name == null || name.isEmpty) return null;
    return _subcategories
        .firstWhere(
          (item) => item.name == name,
          orElse: () => const BrandFilterSubcategoryItemDto(),
        )
        .id;
  }

  String? _findUnitId(String? name) {
    if (name == null || name.isEmpty) return null;
    return _units
        .firstWhere(
          (item) => item.name == name,
          orElse: () => const BrandFilterOptionDto(),
        )
        .id;
  }

  void _showFilterBottomSheet() async {
    final result = await BrandFilterService.showFilterBottomSheet(
      context: context,
      categories: _categories,
      subcategories: _subcategories,
      units: _unitNames,
      currentPriceRange: _priceRange,
      priceBounds: _priceBounds,
      currentSelectedCategory: _selectedCategory,
      currentSelectedSubcategory: _selectedSubcategory,
      currentSelectedUnit: _selectedUnit,
    );

    if (result != null) {
      setState(() {
        _selectedCategory = result['category'] as String?;
        _selectedSubcategory = result['subcategory'] as String?;
        _selectedUnit = result['unit'] as String?;
        _priceRange = result['priceRange'] as RangeValues? ?? _priceBounds;
        _selectedCategoryId = _findCategoryId(_selectedCategory);
        _selectedSubcategoryId = _findSubcategoryId(_selectedSubcategory);
        _selectedUnitId = _findUnitId(_selectedUnit);
      });
      await _loadBrandProducts();
    }
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CustomSortBottomSheet(
        selectedSortOption: _selectedSortOption,
        sortOptions: _sortOptions,
        title: 'ترتيب المنتجات',
      ),
    ).then((result) async {
      if (result != null) {
        setState(() {
          _selectedSortOption = result as String;
        });
        await _loadBrandProducts();
      }
    });
  }

  bool get _hasActivePriceFilter =>
      _priceRange.start != _priceBounds.start ||
      _priceRange.end != _priceBounds.end;

  void _openSearchPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductSearchPage(
          params: ProductSearchParams(
            title: widget.brand.name,
            hintText: 'ابحث في منتجات ${widget.brand.name}',
            brandId: widget.brand.id,
            categoryId: _selectedSubcategoryId ?? _selectedCategoryId,
            minPrice: _priceRange.start,
            maxPrice: _priceRange.end,
            sort: _selectedSortOption.isEmpty ? null : _selectedSortOption,
            autofocus: true,
          ),
        ),
      ),
    );
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
              onSearchTap: _openSearchPage,
            ),
          ),
          if (_categoryNames.isNotEmpty)
            SliverToBoxAdapter(
              child: FilterChipRow(
                categories: _categoryNames,
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) async {
                  setState(() {
                    _selectedCategory = category;
                    _selectedCategoryId = _findCategoryId(category);
                    _selectedSubcategory = null;
                    _selectedSubcategoryId = null;
                  });
                  await _loadBrandProducts();
                },
              ),
            ),
          if (_isLoading)
            const BrandLoadingSkeleton()
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
                        onPressed: _loadBrandData,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            BrandProductsGrid(products: _products),
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
                  _hasActivePriceFilter ||
                  _selectedSortOption.isNotEmpty,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
