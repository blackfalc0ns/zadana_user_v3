import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_user_v3/core/layout/product_grid_layout.dart';
import 'package:zadana_user_v3/core/pagination/models/paginated_section_state.dart';
import 'package:zadana_user_v3/core/utils/home_product_cart_helper.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart'
    show ShimmerEffect;

class PaginatedProductsGridPage extends StatefulWidget {
  const PaginatedProductsGridPage({
    super.key,
    required this.title,
    required this.state,
    required this.onRefresh,
    required this.onRetry,
    required this.onLoadMore,
  });

  final String title;
  final PaginatedSectionState<ProductModel> state;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final Future<void> Function() onLoadMore;

  @override
  State<PaginatedProductsGridPage> createState() =>
      _PaginatedProductsGridPageState();
}

class _PaginatedProductsGridPageState extends State<PaginatedProductsGridPage> {
  static const double _loadMoreThreshold = 320;

  late final ScrollController _scrollController;
  bool _isRequestingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  Future<void> _handleScroll() async {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.extentAfter <= _loadMoreThreshold) {
      await _tryLoadMore();
    }
  }

  Future<void> _tryLoadMore() async {
    if (_isRequestingMore ||
        !widget.state.hasMore ||
        widget.state.isLoading ||
        widget.state.isLoadingMore) {
      return;
    }

    _isRequestingMore = true;
    try {
      await widget.onLoadMore();
    } finally {
      _isRequestingMore = false;
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: Builder(
          builder: (context) {
            if (widget.state.isLoading && widget.state.items.isEmpty) {
              return const _ProductsLoadingGrid();
            }

            if (widget.state.failure != null && widget.state.items.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.7,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ApiErrorWidget(exception: widget.state.failure!.exception,
                          onRetry: widget.onRetry,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (widget.state.items.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(
                    height: 500,
                    child: Center(
                      child: EmptyStateWidget(
                        title: 'Ù„Ø§ ØªÙˆØ¬Ø¯ Ù…Ù†ØªØ¬Ø§Øª',
                        description: 'Ù„Ø§ ØªÙˆØ¬Ø¯ Ø¨ÙŠØ§Ù†Ø§Øª Ù…ØªØ§Ø­Ø© ÙÙŠ Ø§Ù„ÙˆÙ‚Øª Ø§Ù„Ø­Ø§Ù„ÙŠ.',
                        icon: Icons.inventory_2_outlined,
                      ),
                    ),
                  ),
                ],
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final layout = ProductGridLayout.resolve(constraints.maxWidth);

                return GridView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    top: 4,
                    left: Spacing.md,
                    right: Spacing.md,
                    bottom: 85,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: layout.crossAxisCount,
                    childAspectRatio: layout.childAspectRatio,
                    crossAxisSpacing: Spacing.xss,
                    mainAxisSpacing: Spacing.xss,
                  ),
                  itemCount:
                      widget.state.items.length +
                      (widget.state.isLoadingMore ? 3 : 0),
                  itemBuilder: (context, index) {
                    if (index >= widget.state.items.length) {
                      return _ProductCardSkeleton(index: index);
                    }

                    final product = widget.state.items[index];
                    final heroTag = productHeroTag(
                      product.id,
                      source: 'home-section-grid',
                    );
                    return CustomProductCard(
                      discountPercentage: product.discountPercentage,
                      isDiscounted: product.isDiscounted,
                      product: product,
                      heroTag: heroTag,
                      showFavorite: true,
                      onCardTap: () =>
                          ProductNavigationHelper.navigateToProductDetails(
                            context,
                            product,
                            heroTag: heroTag,
                          ),
                      onAddTap: () => HomeProductCartHelper.addProductToCart(
                        context,
                        product,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ProductsLoadingGrid extends StatelessWidget {
  const _ProductsLoadingGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = ProductGridLayout.resolve(constraints.maxWidth);

        return ShimmerEffect(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              top: 4,
              left: Spacing.md,
              right: Spacing.md,
              bottom: 85,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: layout.crossAxisCount,
              childAspectRatio: layout.childAspectRatio,
              crossAxisSpacing: Spacing.xss,
              mainAxisSpacing: Spacing.xss,
            ),
            itemCount: 24,
            itemBuilder: (_, index) => _ProductCardSkeleton(index: index),
          ),
        );
      },
    );
  }
}

class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight = constraints.maxHeight;
        final imageHeight = (cardHeight * 0.46).clamp(52.0, 75.0).toDouble();
        final favoriteSize = (cardHeight * 0.17).clamp(24.0, 28.0).toDouble();
        final cartSize = (cardHeight * 0.17).clamp(24.0, 28.0).toDouble();
        final titleHeight = (cardHeight * 0.07).clamp(10.0, 12.0).toDouble();
        final metaHeight = (cardHeight * 0.06).clamp(8.0, 10.0).toDouble();
        final spacing = (cardHeight * 0.025).clamp(2.0, 4.0).toDouble();
        final horizontalPadding = (constraints.maxWidth * 0.08)
            .clamp(6.0, 8.0)
            .toDouble();
        final bottomPadding = (cardHeight * 0.02).clamp(2.0, 4.0).toDouble();

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(Spacing.cardRadius),
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bone(height: imageHeight, radius: Spacing.cardRadius),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        spacing * 1.5,
                        horizontalPadding,
                        bottomPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Bone(
                            width: switch (index % 4) {
                              0 => 72,
                              1 => 64,
                              2 => 78,
                              _ => 68,
                            },
                            height: titleHeight,
                            radius: 999,
                          ),
                          const Spacer(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _Bone(
                                      width: 40,
                                      height: metaHeight,
                                      radius: 999,
                                    ),
                                    SizedBox(height: spacing),
                                    _Bone(
                                      width: 32,
                                      height: metaHeight,
                                      radius: 999,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: spacing),
                              _Bone(
                                width: cartSize,
                                height: cartSize,
                                radius: 999,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 4,
                right: 4,
                child: _Bone(
                  width: favoriteSize,
                  height: favoriteSize,
                  radius: 999,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({this.width, required this.height, required this.radius});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
