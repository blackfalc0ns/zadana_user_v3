import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/dialogue_utils.dart';
import 'package:zadana_user_v3/core/utils/product_sort_options.dart';
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
import 'package:zadana_user_v3/feature/search/presentation/manager/product_search_cubit.dart';
import 'package:zadana_user_v3/feature/search/presentation/manager/product_search_event.dart';
import 'package:zadana_user_v3/feature/search/presentation/manager/product_search_state.dart';
import 'package:zadana_user_v3/feature/search/presentation/widgets/product_search_results_view.dart';

class BrandDetailsPage extends StatefulWidget {
  const BrandDetailsPage({super.key, required this.brand});

  final BrandModel brand;

  @override
  State<BrandDetailsPage> createState() => _BrandDetailsPageState();
}

class _BrandDetailsPageState extends State<BrandDetailsPage> {
  static const double _loadMoreThreshold = 320;

  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  late final ScrollController _searchScrollController;
  ProductSearchViewModel? _searchViewModel;
  StreamSubscription<ProductSearchState>? _searchStateSubscription;
  String? _searchScopeKey;
  bool _isSearchActive = false;

  BrandModel get brand => widget.brand;

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
    final sortOptions = resolveProductSortOptions(
      context.localization,
      rawOptions: state.sortOptions
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
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CustomSortBottomSheet(
        selectedSortOption: state.selectedSortValue,
        sortOptions: sortOptions,
        title: context.localization.sort_title,
      ),
    ).then((result) async {
      if (result is String?) {
        await cubit.applySortOption(result);
      }
    });
  }

  void _handleScroll() {
    final viewModel = _searchViewModel;
    if (viewModel == null || !_searchScrollController.hasClients) return;
    if (_searchScrollController.position.extentAfter > _loadMoreThreshold) {
      return;
    }
    viewModel.doIntent(const ProductSearchLoadMoreEvent());
  }

  String _buildSearchScopeKey(BrandDetailsState state) {
    return [
      brand.id,
      state.selectedSubcategoryId ?? state.selectedCategoryId ?? '',
      state.priceRange.start.toStringAsFixed(2),
      state.priceRange.end.toStringAsFixed(2),
      state.selectedSortValue,
    ].join('|');
  }

  ProductSearchParams _buildSearchParams(BrandDetailsState state) {
    final hasActivePriceFilter = state.hasActivePriceFilter;

    return ProductSearchParams(
      title: brand.name,
      hintText: context.localization.search_in_brand_products(brand.name),
      brandId: brand.id,
      categoryId: state.selectedSubcategoryId ?? state.selectedCategoryId,
      minPrice: hasActivePriceFilter ? state.priceRange.start : null,
      maxPrice: hasActivePriceFilter ? state.priceRange.end : null,
      sort: state.selectedSortValue.isEmpty ? null : state.selectedSortValue,
      initialQuery: _searchController.text.trim(),
      autofocus: true,
    );
  }

  void _attachSearchStateListener(ProductSearchViewModel viewModel) {
    unawaited(_searchStateSubscription?.cancel());
    _searchStateSubscription = viewModel.stream.listen((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  void _ensureSearchViewModel(BrandDetailsState state) {
    final nextScopeKey = _buildSearchScopeKey(state);
    if (_searchViewModel != null && _searchScopeKey == nextScopeKey) {
      return;
    }

    final previousViewModel = _searchViewModel;
    _searchViewModel = getIt<ProductSearchViewModel>(
      param1: _buildSearchParams(state),
    );
    _attachSearchStateListener(_searchViewModel!);
    _searchScopeKey = nextScopeKey;
    if (previousViewModel != null) {
      unawaited(previousViewModel.close());
    }
    setState(() {});
  }

  void _openInlineSearch(BrandDetailsState state) {
    _ensureSearchViewModel(state);
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

  void _handleBrandStateChanged(BrandDetailsState state) {
    if (!_isSearchActive) return;
    _ensureSearchViewModel(state);
  }

  Future<void> _confirmClearActiveFilters(
    BuildContext context,
    BrandDetailsCubit cubit,
  ) async {
    final l10n = context.localization;
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

    await cubit.clearAllFilters();
  }

  bool _showSearchResults() {
    final viewModel = _searchViewModel;
    if (!_isSearchActive || viewModel == null) {
      return false;
    }

    final searchState = viewModel.state;
    final hasQuery = searchState.query.trim().isNotEmpty;
    return hasQuery;
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
    return BlocProvider(
      create: (_) => getIt<BrandDetailsCubit>(param1: brand)..loadInitial(),
      child: BlocConsumer<BrandDetailsCubit, BrandDetailsState>(
        listener: (_, state) => _handleBrandStateChanged(state),
        builder: (context, state) {
          final cubit = context.read<BrandDetailsCubit>();
          final showClearAction = state.hasActiveFilters;
          final showSearchResults = _showSearchResults();

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                BrandHeader(brand: brand),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: BrandSearchBarDelegate(
                    brandName: brand.name,
                    onSearchTap: () => _openInlineSearch(state),
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: _handleSearchChanged,
                    onClose: _closeInlineSearch,
                    actionIcon: showClearAction
                        ? Icons.delete_outline_rounded
                        : Icons.tune_rounded,
                    actionTooltip: showClearAction
                        ? context.localization.delete_category_tooltip
                        : context.localization.filter_button,
                    isActionDestructive: showClearAction,
                    onActionPressed: showClearAction
                        ? () => _confirmClearActiveFilters(context, cubit)
                        : () => _showFilterBottomSheet(context, cubit, state),
                  ),
                ),
                if (state.categoryNames.isNotEmpty)
                  SliverToBoxAdapter(
                    child: FilterChipRow(
                      categories: state.categories,
                      selectedCategory: state.selectedCategoryName,
                      showAllChip: false,
                      onCategorySelected: (categoryName) async {
                        await cubit.selectCategoryByName(categoryName);
                        final latestState = cubit.state;
                        if (_searchFocusNode.hasFocus ||
                            _searchController.text.trim().isNotEmpty) {
                          _openInlineSearch(latestState);
                        }
                      },
                    ),
                  ),
                if (showSearchResults)
                  SliverFillRemaining(child: _buildSearchResults())
                else if (state.isLoading)
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
