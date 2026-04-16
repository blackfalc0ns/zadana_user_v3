import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_bottom_filter_buttons.dart';
import 'package:zadana_user_v3/core/widgets/custom_sort_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand_details/manager/brand_details_cubit.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand_details/manager/brand_details_state.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand_details/widgets/brand_filter_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand_details/widgets/brand_header.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand_details/widgets/brand_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand_details/widgets/brand_products_grid.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand_details/widgets/brand_search_bar.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand_details/widgets/filter_chip_row.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_params.dart';
import 'package:zadana_user_v3/feature/search/presentation/pages/product_search_page.dart';

class BrandDetailsPage extends StatelessWidget {
  const BrandDetailsPage({super.key, required this.brand});

  final BrandModel brand;

  Future<void> _showFilterBottomSheet(
    BuildContext context,
    BrandDetailsCubit cubit,
    BrandDetailsState state,
  ) async {
    final result = await BrandFilterBottomSheet.show(
      context: context,
      categories: state.categories,
      subcategories: state.subcategories,
      units: state.unitNames,
      currentPriceRange: state.priceRange,
      priceBounds: state.priceBounds,
      currentSelectedCategory: state.selectedCategoryName,
      currentSelectedSubcategory: state.selectedSubcategoryName,
      currentSelectedUnit: state.selectedUnitName,
    );

    if (result != null) {
      await cubit.applyFilters(
        categoryName: result['category'] as String?,
        subcategoryName: result['subcategory'] as String?,
        unitName: result['unit'] as String?,
        priceRange: result['priceRange'] as RangeValues? ?? state.priceBounds,
      );
    }
  }

  void _showSortBottomSheet(
    BuildContext context,
    BrandDetailsCubit cubit,
    BrandDetailsState state,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CustomSortBottomSheet(
        selectedSortOption: state.selectedSortValue,
        sortOptions: state.sortOptions
            .map(
              (item) => {
                'value': item.value,
                'title': item.label.trim().isNotEmpty
                    ? item.label.trim()
                    : item.value,
                'subtitle': null,
              },
            )
            .toList(growable: false),
        title: context.localization.sort_title,
      ),
    ).then((result) async {
      if (result is String?) {
        await cubit.applySortOption(result);
      }
    });
  }

  void _openSearchPage(BuildContext context, BrandDetailsState state) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductSearchPage(
          params: ProductSearchParams(
            title: brand.name,
            hintText: context.localization.search_in_brand_products(brand.name),
            brandId: brand.id,
            categoryId: state.selectedSubcategoryId ?? state.selectedCategoryId,
            minPrice: state.priceRange.start,
            maxPrice: state.priceRange.end,
            sort: state.selectedSortValue.isEmpty
                ? null
                : state.selectedSortValue,
            autofocus: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BrandDetailsCubit>(param1: brand)..loadInitial(),
      child: BlocBuilder<BrandDetailsCubit, BrandDetailsState>(
        builder: (context, state) {
          final cubit = context.read<BrandDetailsCubit>();

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                BrandHeader(brand: brand),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: BrandSearchBarDelegate(
                    brandName: brand.name,
                    onFilterPressed: () =>
                        _showFilterBottomSheet(context, cubit, state),
                    onSearchTap: () => _openSearchPage(context, state),
                  ),
                ),
                if (state.categoryNames.isNotEmpty)
                  SliverToBoxAdapter(
                    child: FilterChipRow(
                      categories: state.categoryNames,
                      selectedCategory: state.selectedCategoryName,
                      showAllChip: false,
                      onCategorySelected: cubit.selectCategoryByName,
                    ),
                  ),
                if (state.isLoading)
                  const BrandLoadingSkeleton()
                else if (state.errorMessage != null)
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
                              state.errorMessage!,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: cubit.loadInitial,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  BrandProductsGrid(products: state.products),
              ],
            ),
            floatingActionButton: state.isLoading || state.errorMessage != null
                ? null
                : CustomBottomFilterButtons(
                    sortLabel: context.localization.sort_button,
                    filterLabel: context.localization.filter_button,
                    onSortPressed: () =>
                        _showSortBottomSheet(context, cubit, state),
                    onFilterPressed: () =>
                        _showFilterBottomSheet(context, cubit, state),
                    hasActiveFilters: state.hasActiveFilters,
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}
