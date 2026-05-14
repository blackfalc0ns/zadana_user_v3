import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/base_error_widget.dart'
    as error_widgets;
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/core/utils/bloc_provider_utils.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_event.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_app_bar.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/best_selling_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/brands_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/categories_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/dynamic_home_preview_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/featured_products_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/home_banner_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/recommended_section.dart';
import 'package:zadana_user_v3/feature/special_offers/presentation/widgets/special_offers_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final existingViewModel = maybeReadBloc<HomeViewModel>(context);
    if (existingViewModel != null) {
      return BlocProvider.value(
        value: existingViewModel,
        child: _HomeScreenView(onMenuTap: onMenuTap),
      );
    }

    final viewModel = getIt<HomeViewModel>();

    return BlocProvider(
      create: (_) => viewModel..doIntent(const HomeLoadEvent()),
      child: _HomeScreenView(onMenuTap: onMenuTap),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView({this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final bottomReservedSpace = mainShellBottomNavReservedSpace(context);

    return Scaffold(
      appBar: HomeAppBar(
        onMenuTap: onMenuTap,
        onLocationTap: () => _openCustomerAddresses(context),
        onSearchTap: () => _openShoppingSearch(context),
        onNotificationsTap: () => _openNotifications(context),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _reloadAllSections(context);
        },
        child: BlocBuilder<HomeViewModel, HomeState>(
          builder: (context, state) {
            final showGlobalError =
                !state.isLoading &&
                state.hasStartedLoadingContent &&
                !state.hasAnyData &&
                state.firstFailure != null;
            final showEmptyState =
                !state.isLoading &&
                state.hasStartedLoadingContent &&
                !state.hasAnyData &&
                state.firstFailure == null;

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
                        child: ApiErrorWidget(
                          exception: state.firstFailure!.exception,
                          onRetry: () {
                            _loadAllSections(context);
                          },
                        ),
                      ),
                    ),
                  )
                else if (showEmptyState)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: error_widgets.BaseErrorWidget(
                      title: context.localization.home_empty_title,
                      description: context.localization.home_empty_description,
                      icon: Icons.storefront_outlined,
                      primaryColor: Theme.of(context).colorScheme.primary,
                      onRetry: () => _reloadAllSections(context),
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
                  const SliverToBoxAdapter(child: DynamicHomePreviewSection()),
                  SliverToBoxAdapter(
                    child: SizedBox(height: bottomReservedSpace),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  void _reloadAllSections(BuildContext context) {
    context.read<HomeViewModel>().doIntent(const HomeRetryEvent());
  }

  void _loadAllSections(BuildContext context) {
    context.read<HomeViewModel>().doIntent(const HomeLoadEvent());
  }

  void _openShoppingSearch(BuildContext context) {
    CategoryNavigationService().requestOpenSearch();
    mainShellKey.currentState?.jumpToTab(1);
  }

  Future<void> _openNotifications(BuildContext context) async {
    await Navigator.of(context).pushNamed(AppRoutes.notifications);
    if (!context.mounted) return;
    // Only refresh the app bar (notification count) instead of reloading everything
    context.read<HomeViewModel>().doIntent(const HomeAppBarLoadEvent());
  }

  Future<void> _openCustomerAddresses(BuildContext context) async {
    await Navigator.of(context).pushNamed(AppRoutes.customerAddresses);
    if (!context.mounted) return;
    // Only refresh the app bar (location) instead of reloading everything
    context.read<HomeViewModel>().doIntent(const HomeAppBarLoadEvent());
  }
}
