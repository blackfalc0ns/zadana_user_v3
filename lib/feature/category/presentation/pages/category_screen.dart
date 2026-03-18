import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/core/widgets/custom_bottom_filter_buttons.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_bottom_sheet.dart';
import 'package:zadana_user_v3/core/widgets/custom_sort_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_chips.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_animal_type_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_category_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_meat_part_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_price_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_quantity_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/products_grid.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/search_bar_widget.dart';

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

  String? _filterSelectedCategory;
  String? _filterSelectedProductType;
  String? _filterSelectedPart;
  String? _filterSelectedQuantity;
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
      });
      _navigationService.clearSelectedCategory();
    }
  }

  void _showBottomSheet(Widget sheet, Function(dynamic)? onResult) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => sheet,
    ).then((result) {
      if (result != null && onResult != null) {
        onResult(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              color: color.surface,
              child: SearchBarWidget(
                locale: locale,
                onFilterApplied: (data) {
                  if (data['category'] != null) {
                    setState(() {
                      _selectedCategory = data['category'];
                      _filterSelectedCategory = data['category'];
                      _filterSelectedQuantity = null;
                    });
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
              child: CategoryChips(
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                    _selectedSubCategory = '';
                    _filterSelectedCategory = category;
                    _filterSelectedQuantity = null;
                  });
                },
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Expanded(
              child: ProductsGrid(
                category: _selectedCategory,
                subCategory: _selectedSubCategory,
                sortOption: _selectedSortOption,
                filters: _selectedFilters,
                selectedQuantity: _filterSelectedQuantity,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomBottomFilterButtons(
        sortLabel: locale.sort_button,
        filterLabel: locale.filter_button,
        onSortPressed: () => _showBottomSheet(
          CustomSortBottomSheet(
            selectedSortOption: _selectedSortOption,
            sortOptions: kSortOptions,
            title: locale.sort_title,
            cancelLabel: locale.cancel,
            applyLabel: locale.apply,
          ),
          (result) {
            if (result != null) {
              setState(() => _selectedSortOption = result);
            }
          },
        ),
        onFilterPressed: () => _showBottomSheet(
          CustomFilterBottomSheet(
            title: 'فلتر المنتجات',
            cancelLabel: locale.cancel,
            clearAllLabel: 'مسح الكل',
            applyLabel: locale.apply,
            children: [
              FilterPriceSection(
                priceRange: _priceRange,
                onPriceRangeChanged: (values) =>
                    setState(() => _priceRange = values),
              ),
              const SizedBox(height: Spacing.base),
              FilterCategorySection(
                selectedCategory: _filterSelectedCategory,
                onCategorySelected: (category) => setState(() {
                  _filterSelectedCategory = category;
                  _filterSelectedProductType = null;
                  _filterSelectedPart = null;
                  _filterSelectedQuantity = null;
                }),
              ),
              FilterAnimalTypeSection(
                selectedCategory: _filterSelectedCategory,
                selectedProductType: _filterSelectedProductType,
                onProductTypeSelected: (type) => setState(() {
                  _filterSelectedProductType = type;
                  _filterSelectedPart = null;
                }),
              ),
              const SizedBox(height: Spacing.base),
              FilterMeatPartSection(
                selectedCategory: _filterSelectedCategory,
                selectedProductType: _filterSelectedProductType,
                selectedPart: _filterSelectedPart,
                onPartSelected: (part) =>
                    setState(() => _filterSelectedPart = part),
              ),
              if (_filterSelectedPart != null)
                const SizedBox(height: Spacing.base),
              FilterQuantitySection(
                selectedCategory: _filterSelectedCategory,
                selectedQuantity: _filterSelectedQuantity,
                onQuantitySelected: (quantity) =>
                    setState(() => _filterSelectedQuantity = quantity),
              ),
            ],
            onApply: () => Navigator.pop(context, {
              'category': _filterSelectedCategory,
              'productType': _filterSelectedProductType,
              'part': _filterSelectedPart,
              'quantity': _filterSelectedQuantity,
              'priceRange': _priceRange,
            }),
            onClearAll: () => setState(() {
              _filterSelectedCategory = null;
              _filterSelectedProductType = null;
              _filterSelectedPart = null;
              _filterSelectedQuantity = null;
              _priceRange = const RangeValues(0, 1000);
            }),
          ),
          (result) {
            if (result != null) {
              setState(() {
                _filterSelectedCategory = result['category'];
                _filterSelectedProductType = result['productType'];
                _filterSelectedPart = result['part'];
                _filterSelectedQuantity = result['quantity'];
                _priceRange =
                    result['priceRange'] ?? const RangeValues(0, 1000);

                if (_filterSelectedCategory != null) {
                  _selectedCategory = _filterSelectedCategory!;
                  _selectedSubCategory = '';
                }
              });
            }
          },
        ),
        hasActiveFilters: _selectedFilters.isNotEmpty ||
            _selectedSortOption.isNotEmpty ||
            _filterSelectedCategory != null ||
            _filterSelectedProductType != null ||
            _filterSelectedPart != null ||
            _filterSelectedQuantity != null ||
            _priceRange.start != 0 ||
            _priceRange.end != 1000,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
