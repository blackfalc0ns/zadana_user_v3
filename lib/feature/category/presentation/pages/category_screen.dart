import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/core/services/favorite_sync_service.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_state.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_view_model.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/reusable_category_screen.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_params.dart';
import 'package:zadana_user_v3/feature/search/presentation/pages/product_search_page.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String? _activeHeroProductId;

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

  void _openSearch(BuildContext context) {
    final l10n = context.localization;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductSearchPage(
          params: ProductSearchParams(
            title: l10n.search_marketplace_title,
            hintText: l10n.search_hint,
            autofocus: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryViewModel(
        getIt<ApiServices>(),
        CategoryNavigationService(),
        FavoriteSyncService(),
      )..initialize(),
      child: BlocBuilder<CategoryViewModel, CategoryState>(
        builder: (context, state) {
          return ReusableCategoryScreen(
            categories: state.categories,
            selectedCategory: state.selectedCategory,
            selectedSubCategory: state.selectedSubCategory ?? '',
            selectedSubCategoryId: state.selectedSubCategoryId,
            selectedSortOption: state.selectedSortOption,
            selectedFilters: const [],
            products: state.products,
            availableBrands: state.availableBrands,
            availableQuantities: state.availableQuantities,
            availableProductTypes: state.availableProductTypes,
            availableParts: state.availableParts,
            selectedQuantity: state.filterSelectedQuantity,
            selectedProductType: state.filterSelectedProductType,
            selectedPart: state.filterSelectedPart,
            filterSelectedCategory: state.filterSelectedCategory,
            filterSelectedQuantity: state.filterSelectedQuantity,
            filterSelectedBrand: state.filterSelectedBrand,
            priceRange: state.priceRange,
            priceBounds: state.priceBounds,
            isLoading: state.isLoading,
            subCategories: state.subCategories,
            isSubCategoriesLoading: state.isSubCategoriesLoading,
            emptyStateMessage: state.errorMessage,
            errorFailure: state.failure,
            onRetryError: context.read<CategoryViewModel>().retry,
            onCategorySelected: context
                .read<CategoryViewModel>()
                .selectCategoryByName,
            onSubCategorySelected: context
                .read<CategoryViewModel>()
                .selectSubCategory,
            onFilterApplied: context.read<CategoryViewModel>().applyFilters,
            onSortChanged: context.read<CategoryViewModel>().applySort,
            onFilterChanged: context.read<CategoryViewModel>().applyFilters,
            onClearAllFilters: context
                .read<CategoryViewModel>()
                .clearAllFilters,
            sortOptions: state.sortOptions,
            hasActiveFilters: state.hasActiveFilters,
            bottomNavHeight: 60,
            activeHeroProductId: _activeHeroProductId,
            onProductTap: _openProductDetails,
            onSearchTap: () => _openSearch(context),
          );
        },
      ),
    );
  }
}
