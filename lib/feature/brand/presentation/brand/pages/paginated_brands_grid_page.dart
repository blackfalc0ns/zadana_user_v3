import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/pagination/models/paginated_section_state.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand/manager/brands_listing_cubit.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand/widgets/brands_grid_widgets.dart';

class PaginatedBrandsGridPage extends StatelessWidget {
  const PaginatedBrandsGridPage({
    super.key,
    required this.cubit,
    required this.state,
  });

  final BrandsListingCubit cubit;
  final PaginatedSectionState<BrandModel> state;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Scaffold(
      appBar: CustomAppBar(
        title: state.title.isEmpty ? locale.section_brands : state.title,
      ),
      body: RefreshIndicator(
        onRefresh: cubit.refresh,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis == Axis.vertical) {
              cubit.handleScrollExtent(notification.metrics.extentAfter);
            }
            return false;
          },
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final locale = context.localization;

    if (state.isLoading && state.items.isEmpty) {
      return const BrandsLoadingView();
    }

    if (state.failure != null && state.items.isEmpty) {
      return BrandsErrorView(
        failure: state.failure!,
        onRetry: cubit.loadInitial,
      );
    }

    if (state.items.isEmpty) {
      return BrandsEmptyView(
        title: locale.brands_unavailable,
        description: locale.brands_empty_description,
      );
    }

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(Spacing.md, 0, Spacing.md, 72),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index >= state.items.length) {
                return const BrandCardSkeleton();
              }

              return BrandGridTile(brand: state.items[index]);
            }, childCount: state.items.length + (state.isLoadingMore ? 3 : 0)),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.82,
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
            ),
          ),
        ),
      ],
    );
  }
}
