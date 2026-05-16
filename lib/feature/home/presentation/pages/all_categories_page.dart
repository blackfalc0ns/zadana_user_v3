import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/all_categories/all_categories_event.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/all_categories/all_categories_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/all_categories/all_categories_view_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';

class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AllCategoriesViewModel>()
        ..doIntent(const AllCategoriesLoadEvent()),
      child: const _AllCategoriesView(),
    );
  }
}

class _AllCategoriesView extends StatefulWidget {
  const _AllCategoriesView();

  @override
  State<_AllCategoriesView> createState() => _AllCategoriesViewState();
}

class _AllCategoriesViewState extends State<_AllCategoriesView> {
  static const double _loadMoreThreshold = 200;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter <= _loadMoreThreshold) {
      context.read<AllCategoriesViewModel>().doIntent(
        const AllCategoriesLoadMoreEvent(),
      );
    }
  }

  void _onCategoryTap(CategoryEntity category) {
    CategoryNavigationService().setSelectedCategory(category);
    Navigator.pop(context);
    mainShellKey.currentState?.jumpToTab(1);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Scaffold(
      appBar: CustomAppBar(title: locale.categ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AllCategoriesViewModel>().doIntent(
            const AllCategoriesRefreshEvent(),
          );
        },
        child: BlocBuilder<AllCategoriesViewModel, AllCategoriesState>(
          builder: _buildBody,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AllCategoriesState state) {
    final color = context.colorScheme;

    if (state.isLoading && state.categories.isEmpty) {
      return const _CategoriesLoadingGrid();
    }

    if (state.failure != null && state.categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: color.error),
            const SizedBox(height: 16),
            Text(
              context.localization.categ,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<AllCategoriesViewModel>().doIntent(
                  const AllCategoriesLoadEvent(),
                );
              },
              child: Text(context.localization.refresh),
            ),
          ],
        ),
      );
    }

    if (state.categories.isEmpty) {
      return Center(
        child: Text(
          'لا توجد أقسام',
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: color.onSurfaceVariant,
          ),
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(Spacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.78,
        crossAxisSpacing: Spacing.sm,
        mainAxisSpacing: Spacing.md,
      ),
      itemCount: state.categories.length + (state.isLoadingMore ? 3 : 0),
      itemBuilder: (context, index) {
        if (index >= state.categories.length) {
          return const _CategoryItemSkeleton();
        }

        final category = state.categories[index];
        return _CategoryGridItem(
          category: category,
          onTap: () => _onCategoryTap(category),
        );
      },
    );
  }
}

class _CategoryGridItem extends StatelessWidget {
  const _CategoryGridItem({
    required this.category,
    required this.onTap,
  });

  final CategoryEntity category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.surfaceContainerLowest,
              boxShadow: [
                BoxShadow(
                  color: color.shadow.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: CachedNetworkImage(
              imageUrl: category.imageAsset,
              fit: BoxFit.contain,
              placeholder: (_, _) => const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 0.5,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              errorWidget: (_, _, _) =>
                  Image.asset(Assets.notFound, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Flexible(
            child: Text(
              category.name,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesLoadingGrid extends StatelessWidget {
  const _CategoriesLoadingGrid();

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(Spacing.md),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.78,
          crossAxisSpacing: Spacing.sm,
          mainAxisSpacing: Spacing.md,
        ),
        itemCount: 20,
        itemBuilder: (_, _) => const _CategoryItemSkeleton(),
      ),
    );
  }
}

class _CategoryItemSkeleton extends StatelessWidget {
  const _CategoryItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.shimmerBase,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Container(
          width: 60,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.shimmerBase,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}
