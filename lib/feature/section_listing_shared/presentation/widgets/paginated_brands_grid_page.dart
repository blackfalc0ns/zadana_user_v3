import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/brand/presentation/pages/brand_page.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/brand_card.dart';
import 'package:zadana_user_v3/feature/section_listing_shared/presentation/manager/paginated_section_state.dart';

class PaginatedBrandsGridPage extends StatefulWidget {
  const PaginatedBrandsGridPage({
    super.key,
    required this.title,
    required this.state,
    required this.onRefresh,
    required this.onRetry,
    required this.onLoadMore,
  });

  final String title;
  final PaginatedSectionState<BrandModel> state;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final Future<void> Function() onLoadMore;

  @override
  State<PaginatedBrandsGridPage> createState() =>
      _PaginatedBrandsGridPageState();
}

class _PaginatedBrandsGridPageState extends State<PaginatedBrandsGridPage> {
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
      appBar: AppBar(
        title: Text(
          widget.state.title.isEmpty ? widget.title : widget.state.title,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: Builder(
          builder: (context) {
            if (widget.state.isLoading && widget.state.items.isEmpty) {
              return const _BrandsLoadingGrid();
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
                        child: ApiErrorWidget.fromFailure(
                          widget.state.failure!,
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
                        title: 'لا توجد علامات تجارية',
                        description: 'لا توجد بيانات متاحة في الوقت الحالي.',
                        icon: Icons.storefront_outlined,
                      ),
                    ),
                  ),
                ],
              );
            }

            return GridView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                Spacing.md,
                Spacing.md,
                Spacing.md,
                96,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                crossAxisSpacing: Spacing.sm,
                mainAxisSpacing: Spacing.sm,
              ),
              itemCount:
                  widget.state.items.length +
                  (widget.state.isLoadingMore ? 3 : 0),
              itemBuilder: (context, index) {
                if (index >= widget.state.items.length) {
                  return const _BrandCardSkeleton();
                }

                final brand = widget.state.items[index];
                return BrandCard(
                  name: brand.name,
                  emoji: brand.emoji ?? brand.name.substring(0, 1),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BrandPage(brand: brand),
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

class _BrandsLoadingGrid extends StatelessWidget {
  const _BrandsLoadingGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(Spacing.md, Spacing.md, Spacing.md, 96),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: Spacing.sm,
        mainAxisSpacing: Spacing.sm,
      ),
      itemCount: 9,
      itemBuilder: (_, _) => const _BrandCardSkeleton(),
    );
  }
}

class _BrandCardSkeleton extends StatelessWidget {
  const _BrandCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.xs),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 56,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }
}
