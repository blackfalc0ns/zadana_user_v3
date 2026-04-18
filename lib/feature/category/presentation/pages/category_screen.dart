import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/bloc_provider_utils.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_event.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_state.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_view_model.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_view_model_factory.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/reusable_category_screen.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_params.dart';
import 'package:zadana_user_v3/feature/search/presentation/manager/product_search_cubit.dart';
import 'package:zadana_user_v3/feature/search/presentation/manager/product_search_event.dart';
import 'package:zadana_user_v3/feature/search/presentation/manager/product_search_state.dart';
import 'package:zadana_user_v3/feature/search/presentation/widgets/product_search_results_view.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  static const double _loadMoreThreshold = 320;

  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  late final ScrollController _searchScrollController;
  ProductSearchViewModel? _searchViewModel;
  StreamSubscription<ProductSearchState>? _searchStateSubscription;
  String? _searchScopeSubCategoryId;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _searchScrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchScrollController
      ..removeListener(_handleScroll)
      ..dispose();
    unawaited(_searchStateSubscription?.cancel());
    unawaited(_searchViewModel?.close());
    super.dispose();
  }

  Future<void> _openProductDetails(ProductModel product) async {
    context.read<CategoryViewModel>().doIntent(
      CategorySetActiveHeroProductEvent(product.id),
    );
    await WidgetsBinding.instance.endOfFrame;

    if (!mounted) return;

    await ProductNavigationHelper.navigateToProductDetails(
      context,
      product,
      heroTag: productHeroTag(product.id, source: 'category-grid'),
    );

    if (!mounted) return;
    context.read<CategoryViewModel>().doIntent(
      const CategorySetActiveHeroProductEvent(null),
    );
  }

  void _handleScroll() {
    final viewModel = _searchViewModel;
    if (viewModel == null || !_searchScrollController.hasClients) return;
    if (_searchScrollController.position.extentAfter > _loadMoreThreshold) {
      return;
    }
    viewModel.doIntent(const ProductSearchLoadMoreEvent());
  }

  String? _resolveSearchCategoryId(CategoryState state) {
    final subCategoryId = state.selectedSubCategoryId;
    if (subCategoryId == null || subCategoryId.isEmpty) {
      return null;
    }
    return subCategoryId;
  }

  ProductSearchParams _buildSearchParams(
    BuildContext context,
    CategoryState state,
  ) {
    final l10n = context.localization;

    return ProductSearchParams(
      title: l10n.search_marketplace_title,
      hintText: l10n.search_hint,
      categoryId: _resolveSearchCategoryId(state),
      initialQuery: _searchController.text.trim(),
      autofocus: true,
    );
  }

  void _ensureSearchViewModel(BuildContext context, CategoryState state) {
    final categoryViewModel = context.read<CategoryViewModel>();
    final nextScopeSubCategoryId = _resolveSearchCategoryId(state);
    if (_searchViewModel != null &&
        _searchScopeSubCategoryId == nextScopeSubCategoryId) {
      return;
    }

    final previousViewModel = _searchViewModel;
    _searchViewModel = getIt<ProductSearchViewModel>(
      param1: _buildSearchParams(context, state),
    );
    _attachSearchStateListener(_searchViewModel!, categoryViewModel);
    _searchScopeSubCategoryId = nextScopeSubCategoryId;
    categoryViewModel.doIntent(const CategoryRefreshSearchSessionEvent());
    if (previousViewModel != null) {
      unawaited(previousViewModel.close());
    }
  }

  void _attachSearchStateListener(
    ProductSearchViewModel viewModel,
    CategoryViewModel categoryViewModel,
  ) {
    unawaited(_searchStateSubscription?.cancel());
    categoryViewModel.doIntent(
      CategorySyncSearchPresentationEvent(
        query: viewModel.state.query,
        isLoading: viewModel.state.isLoading,
        hasItems: viewModel.state.items.isNotEmpty,
        hasFailure: viewModel.state.failure != null,
      ),
    );
    _searchStateSubscription = viewModel.stream.listen((_) {
      if (!mounted) return;
      categoryViewModel.doIntent(
        CategorySyncSearchPresentationEvent(
          query: viewModel.state.query,
          isLoading: viewModel.state.isLoading,
          hasItems: viewModel.state.items.isNotEmpty,
          hasFailure: viewModel.state.failure != null,
        ),
      );
    });
  }

  void _openInlineSearch(BuildContext context, CategoryState state) {
    _ensureSearchViewModel(context, state);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  void _closeInlineSearch() {
    _searchController.clear();
    _searchViewModel?.doIntent(const ProductSearchQueryChangedEvent(''));
    _searchFocusNode.unfocus();
    context.read<CategoryViewModel>().doIntent(
      const CategoryCloseSearchUiEvent(),
    );
  }

  void _handleSearchChanged(String value) {
    context.read<CategoryViewModel>().doIntent(
      CategorySearchQueryChangedEvent(value),
    );
    _searchViewModel?.doIntent(ProductSearchQueryChangedEvent(value));
  }

  void _handleCategoryStateChanged(BuildContext context, CategoryState state) {
    if (!state.isSearchActive) return;

    final nextScopeSubCategoryId = _resolveSearchCategoryId(state);
    if (_searchViewModel == null ||
        _searchScopeSubCategoryId != nextScopeSubCategoryId) {
      _ensureSearchViewModel(context, state);
    }
  }

  Widget _buildSearchResults() {
    final viewModel = _searchViewModel;
    if (viewModel == null) {
      return const SizedBox.shrink();
    }

    return BlocProvider.value(
      value: viewModel,
      child: ProductSearchResultsView(
        scrollController: _searchScrollController,
        onRetry: () => viewModel.doIntent(const ProductSearchRetryEvent()),
        onRefresh: () async =>
            viewModel.doIntent(const ProductSearchRefreshEvent()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final existingViewModel = maybeReadBloc<CategoryViewModel>(context);
    if (existingViewModel != null) {
      return BlocProvider.value(
        value: existingViewModel,
        child: _buildContent(),
      );
    }

    return BlocProvider(
      create: (_) => createCategoryViewModel()..initialize(),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return BlocConsumer<CategoryViewModel, CategoryState>(
      listener: _handleCategoryStateChanged,
      builder: (context, state) {
        return ReusableCategoryScreen(
          categories: state.categories,
          isSearchActive: state.isSearchActive,
          showSearchResults: state.showSearchResults,
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
          onRetryError: () => context.read<CategoryViewModel>().doIntent(
            const CategoryRetryEvent(),
          ),
          onCategorySelected: (categoryName) => context
              .read<CategoryViewModel>()
              .doIntent(CategorySelectCategoryByNameEvent(categoryName)),
          onSubCategorySelected: (subCategory) => context
              .read<CategoryViewModel>()
              .doIntent(CategorySelectSubCategoryEvent(subCategory)),
          onFilterApplied: (filters) => context
              .read<CategoryViewModel>()
              .doIntent(CategoryApplyFiltersEvent(filters)),
          onSortChanged: (sortValue) => context
              .read<CategoryViewModel>()
              .doIntent(CategoryApplySortEvent(sortValue)),
          onFilterChanged: (filters) => context
              .read<CategoryViewModel>()
              .doIntent(CategoryApplyFiltersEvent(filters)),
          onClearAllFilters: () => context.read<CategoryViewModel>().doIntent(
            const CategoryClearAllFiltersEvent(),
          ),
          sortOptions: state.sortOptions,
          hasActiveFilters: state.hasActiveFilters,
          bottomNavHeight: 60,
          activeHeroProductId: state.activeHeroProductId,
          onProductTap: _openProductDetails,
          onSearchTap: () => _openInlineSearch(context, state),
          searchController: _searchController,
          searchFocusNode: _searchFocusNode,
          onSearchChanged: _handleSearchChanged,
          onSearchClose: (state.isSearchActive || state.hasSearchQuery)
              ? _closeInlineSearch
              : null,
          searchResults: _buildSearchResults(),
        );
      },
    );
  }
}
