import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_app_bar.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_event.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/best_selling_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/categories_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/explore_more_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/featured_products_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/home_banner_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/recommended_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/special_offers_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/brands_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final viewModel = getIt<HomeViewModel>();

    return BlocProvider(
      create: (_) => viewModel
        ..doIntent(const HomeLoadEvent())
        ..doIntent(const HomeBannerLoadEvent())
        ..doIntent(const HomeCategoriesLoadEvent())
        ..doIntent(const HomeBestSellingLoadEvent())
        ..doIntent(const HomeBrandsLoadEvent())
        ..doIntent(const HomeRecommendedLoadEvent())
        ..doIntent(const HomeFeaturedLoadEvent())
        ..doIntent(const HomeSpecialOffersLoadEvent())
        ..doIntent(const HomeExploreMoreLoadEvent()),
      child: _HomeScreenView(onMenuTap: onMenuTap),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView({this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(onMenuTap: onMenuTap),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeViewModel>()
            ..doIntent(const HomeRetryEvent())
            ..doIntent(const HomeBannerRetryEvent())
            ..doIntent(const HomeCategoriesRetryEvent())
            ..doIntent(const HomeBestSellingRetryEvent())
            ..doIntent(const HomeBrandsRetryEvent())
            ..doIntent(const HomeRecommendedRetryEvent())
            ..doIntent(const HomeFeaturedRetryEvent())
            ..doIntent(const HomeSpecialOffersRetryEvent())
            ..doIntent(const HomeExploreMoreRetryEvent());
        },
        child: BlocBuilder<HomeViewModel, HomeState>(
          builder: (context, state) {
            final showGlobalError =
                !state.isLoading &&
                !state.hasAnyData &&
                state.firstFailure != null;

            return CustomScrollView(
              key: const PageStorageKey<String>('home_scroll_view'),
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: Spacing.sm)),

                if (showGlobalError)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: ApiErrorWidget.fromFailure(
                          state.firstFailure!,
                          onRetry: () {
                            context.read<HomeViewModel>()
                              ..doIntent(const HomeLoadEvent())
                              ..doIntent(const HomeBannerLoadEvent())
                              ..doIntent(const HomeCategoriesLoadEvent())
                              ..doIntent(const HomeBestSellingLoadEvent())
                              ..doIntent(const HomeBrandsLoadEvent())
                              ..doIntent(const HomeRecommendedLoadEvent())
                              ..doIntent(const HomeFeaturedLoadEvent())
                              ..doIntent(const HomeSpecialOffersLoadEvent())
                              ..doIntent(const HomeExploreMoreLoadEvent());
                          },
                        ),
                      ),
                    ),
                  )
                else ...[
                  const SliverToBoxAdapter(child: HomeBannerSection()),
                  const SliverToBoxAdapter(child: CategoriesSection()),
                  const SliverToBoxAdapter(child: SpecialOffersSection()),
                  const SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),
                  const SliverToBoxAdapter(child: RecommendedSection()),
                  const SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),
                  const SliverToBoxAdapter(child: BestSellingSection()),
                  const SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),
                  const SliverToBoxAdapter(child: BrandsSection()),
                  const SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),
                  const SliverToBoxAdapter(child: FeaturedProductsSection()),
                  const SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),
                  const SliverToBoxAdapter(child: ExploreMoreSection()),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
