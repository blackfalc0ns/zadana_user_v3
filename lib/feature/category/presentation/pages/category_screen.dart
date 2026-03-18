import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_chips.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/products_grid.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/search_bar_widget.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/sort_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/bottom_filter_buttons.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String selectedCategory = 'خضروات';
  String selectedSubCategory = '';
  String selectedSortOption = '';
  List<String> selectedFilters = [];

  late CategoryNavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _navigationService = CategoryNavigationService();
    _navigationService.addListener(_onNavigationServiceChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSelectedCategoryFromHome();
    });
  }

  @override
  void dispose() {
    _navigationService.removeListener(_onNavigationServiceChanged);
    super.dispose();
  }

  void _onNavigationServiceChanged() {
    _checkSelectedCategoryFromHome();
  }

  void _checkSelectedCategoryFromHome() {
    final categoryName = _navigationService.getCategoryNameForScreen();

    if (categoryName != null &&
        kCategorySubCategories.containsKey(categoryName)) {
      if (mounted) {
        setState(() {
          selectedCategory = categoryName;
          selectedSubCategory = '';
        });

        _navigationService.clearSelectedCategory();
      }
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          FilterBottomSheet(preSelectedCategory: selectedCategory),
    ).then((result) {
      if (result != null) {
        setState(() {
          if (result['category'] != null) {
            selectedCategory = result['category'];
          }
        });
      }
    });
  }

  void _showSortBottomSheet() {
    final locale = context.localization;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheet(
        selectedSortOption: selectedSortOption,
        locale: locale,
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          selectedSortOption = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SearchBarWidget(
                locale: locale,
                onFilterApplied: (filterData) {
                  setState(() {
                    if (filterData['category'] != null) {
                      selectedCategory = filterData['category'];
                    }
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
              child: CategoryChips(
                selectedCategory: selectedCategory,
                locale: locale,
                onCategorySelected: (category) {
                  setState(() {
                    selectedCategory = category;
                    selectedSubCategory = '';
                  });
                },
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Expanded(
              child: ProductsGrid(
                category: selectedCategory,
                subCategory: selectedSubCategory,
                sortOption: selectedSortOption,
                filters: selectedFilters,
              ),
            ),
            // SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: BottomFilterButtons(
          locale: locale,
          onSortPressed: _showSortBottomSheet,
          onCategoryPressed: _showFilterBottomSheet,
          hasActiveFilters:
              selectedFilters.isNotEmpty || selectedSortOption.isNotEmpty,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
