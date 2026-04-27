import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/dialogue_utils.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/core/utils/bloc_provider_utils.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_event.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_state.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_view_model.dart';
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
  late final CategoryNavigationService _categoryNavigationService;
  ProductSearchViewModel? _searchViewModel;
  StreamSubscription<ProductSearchState>? _searchStateSubscription;
  CategoryState? _latestCategoryState;
  String? _searchScopeSubCategoryId;
  bool _isSearchActive = false;
  bool _isResettingFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _searchScrollController = ScrollController()..addListener(_handleScroll);
    _categoryNavigationService = CategoryNavigationService()
      ..addListener(_handleExternalSearchRequest);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _handleExternalSearchRequest();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchScrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _categoryNavigationService.removeListener(_handleExternalSearchRequest);
    unawaited(_searchStateSubscription?.cancel());
    unawaited(_searchViewModel?.close());
    super.dispose();
  }

  void _handleExternalSearchRequest() {
    if (!_categoryNavigationService.hasPendingSearchRequest) {
      return;
    }

    final state = _latestCategoryState;
    if (state == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _handleExternalSearchRequest();
        }
      });
      return;
    }

    _categoryNavigationService.consumeOpenSearchRequest();
    if (_isSearchActive) {
      _searchFocusNode.requestFocus();
      return;
    }

    _openInlineSearch(context, state);
  }

  Future<void> _openProductDetails(ProductModel product) async {
    _searchFocusNode.unfocus();
    FocusScope.of(context).unfocus();

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
    final nextScopeSubCategoryId = _resolveSearchCategoryId(state);
    if (_searchViewModel != null &&
        _searchScopeSubCategoryId == nextScopeSubCategoryId) {
      return;
    }

    final previousViewModel = _searchViewModel;
    _searchViewModel = getIt<ProductSearchViewModel>(
      param1: _buildSearchParams(context, state),
    );
    _attachSearchStateListener(_searchViewModel!);
    _searchScopeSubCategoryId = nextScopeSubCategoryId;
    if (previousViewModel != null) {
      unawaited(previousViewModel.close());
    }
    setState(() {});
  }

  void _attachSearchStateListener(ProductSearchViewModel viewModel) {
    unawaited(_searchStateSubscription?.cancel());
    _searchStateSubscription = viewModel.stream.listen((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  void _openInlineSearch(BuildContext context, CategoryState state) {
    _ensureSearchViewModel(context, state);
    setState(() {
      _isSearchActive = true;
    });

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
    setState(() {
      _isSearchActive = false;
    });
  }

  void _handleSearchChanged(String value) {
    _searchViewModel?.doIntent(ProductSearchQueryChangedEvent(value));
  }

  Future<void> _confirmResetSelection(BuildContext context) async {
    final l10n = context.localization;
    final viewModel = context.read<CategoryViewModel>();
    final errorColor = context.colorScheme.error;
    final confirmed = await DialogueUtils.showCompactConfirmationDialog(
      context: context,
      title: l10n.delete_category_title,
      message: l10n.delete_category_confirm,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.no,
      icon: Icons.delete_outline_rounded,
      accentColor: errorColor,
    );

    if (!mounted || !confirmed) {
      return;
    }

    setState(() {
      _isResettingFilters = true;
    });
    viewModel.doIntent(const CategoryResetSelectionEvent());
  }

  void _clearActiveFilters(BuildContext context) {
    _confirmClearActiveFilters(context);
  }

  Future<void> _confirmClearActiveFilters(BuildContext context) async {
    final l10n = context.localization;
    final viewModel = context.read<CategoryViewModel>();
    final confirmed = await DialogueUtils.showCompactConfirmationDialog(
      context: context,
      title: l10n.clear_filters_title,
      message: l10n.clear_filters_confirm,
      confirmLabel: l10n.clear_all,
      cancelLabel: l10n.cancel,
      icon: Icons.filter_alt_off_rounded,
      accentColor: context.colorScheme.error,
    );

    if (!mounted || !confirmed) {
      return;
    }

    setState(() {
      _isResettingFilters = true;
    });
    viewModel.doIntent(const CategoryClearAllFiltersEvent());
  }

  void _handleCategoryStateChanged(BuildContext context, CategoryState state) {
    if (_isResettingFilters && mounted) {
      setState(() {
        _isResettingFilters = false;
      });
    }

    if (!_isSearchActive) return;

    final nextScopeSubCategoryId = _resolveSearchCategoryId(state);
    if (_searchViewModel == null ||
        _searchScopeSubCategoryId != nextScopeSubCategoryId) {
      _ensureSearchViewModel(context, state);
    }
  }

  bool _showSearchResults() {
    final viewModel = _searchViewModel;
    if (!_isSearchActive || viewModel == null) {
      return false;
    }

    final searchState = viewModel.state;
    final hasQuery = searchState.query.trim().isNotEmpty;
    return hasQuery &&
        !(searchState.isLoading &&
            searchState.items.isEmpty &&
            searchState.failure == null);
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
      create: (_) => getIt<CategoryViewModel>()..initialize(),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return BlocConsumer<CategoryViewModel, CategoryState>(
      listener: _handleCategoryStateChanged,
      builder: (context, state) {
        _latestCategoryState = state;
        final showSearchResults = _showSearchResults();
        final hasSearchQuery = _searchController.text.trim().isNotEmpty;
        final hasSelectedCategory =
            (state.selectedCategoryId?.isNotEmpty ?? false) ||
            (state.selectedSubCategoryId?.isNotEmpty ?? false);
        final hasClearableFilters = state.hasNonCategoryActiveFilters;
        final showClearAction =
            !_isResettingFilters &&
            (hasSelectedCategory || hasClearableFilters);
        return ReusableCategoryScreen(
          categories: state.categories,
          isSearchActive: _isSearchActive,
          showSearchResults: showSearchResults,
          selectedCategory: state.selectedCategory,
          selectedCategoryId: state.selectedCategoryId,
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
          subCategoryCategoryMap: state.subCategoryCategoryMap,
          isSubCategoriesLoading: state.isSubCategoriesLoading,
          emptyStateMessage: state.errorMessage,
          errorFailure: state.failure,
          onRetryError: () => context.read<CategoryViewModel>().doIntent(
            const CategoryRetryEvent(),
          ),
          onCategorySelected: (categoryId) => context
              .read<CategoryViewModel>()
              .doIntent(CategorySelectCategoryEvent(categoryId)),
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
          onSearchClose: (_isSearchActive || hasSearchQuery)
              ? _closeInlineSearch
              : null,
          onSearchActionTap: !showClearAction
              ? null
              : hasSelectedCategory
              ? () => _confirmResetSelection(context)
              : () => _clearActiveFilters(context),
          searchActionIcon: showClearAction
              ? Icons.delete_outline_rounded
              : Icons.tune_rounded,
          searchActionTooltip: hasSelectedCategory
              ? context.localization.delete_category_tooltip
              : hasClearableFilters
              ? context.localization.clear_all
              : null,
          isSearchActionDestructive: showClearAction,
          searchResults: _buildSearchResults(),
        );
      },
    );
  }
}
