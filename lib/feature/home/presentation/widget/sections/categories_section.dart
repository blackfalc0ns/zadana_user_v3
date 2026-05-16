import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_category_item_entity.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.categoriesSection != current.categoriesSection,
      builder: (context, state) {
        if (state.categoriesSection.isLoading) {
          return const ShimmerEffect(child: CategoriesSectionSkeleton());
        }

        final section = state.categoriesSection.data;
        if (section?.isActive == false) {
          return const SizedBox.shrink();
        }

        if (state.categoriesSection.failure != null &&
            state.categoriesSection.data == null) {
          return const SizedBox.shrink();
        }

        final items = section?.items ?? const <HomeCategoryItemEntity>[];
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            SectionHeader(
              title: locale.categ,
              actionLabel: locale.see_all,
              onActionTap: () {
                Navigator.of(context).pushNamed(AppRoutes.allCategories);
              },
            ),
            const SizedBox(height: Spacing.md),
            SizedBox(
              height: 126,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
                itemBuilder: (_, index) {
                  return _HomeCategoryItem(category: items[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HomeCategoryItem extends StatelessWidget {
  
  const _HomeCategoryItem({required this.category});

  final HomeCategoryItemEntity category;

  @override
  Widget build(BuildContext context) {
    
    final color = context.colorScheme;

    return GestureDetector(
      onTap: () {
        CategoryNavigationService().setSelectedCategory(
          CategoryEntity(
            id: category.id,
            name: category.name,
            imageAsset: category.imageUrl,
            emoji: category.name.isNotEmpty
                ? category.name.substring(0, 1)
                : '',
          ),
        );
        mainShellKey.currentState?.jumpToTab(1);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.surfaceContainerLowest,

              boxShadow: [
                BoxShadow(
                  color: color.shadow.withValues(alpha: 0.05),

                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CachedNetworkImage(
              imageUrl: category.imageUrl,
              fit: BoxFit.contain,
              placeholder: (_, _) =>
                  const Center(child: CircularProgressIndicator(
                    strokeWidth: .5,
              valueColor: AlwaysStoppedAnimation(AppColors.primary
              ),
                  )),
              errorWidget: (_, _, _) =>
                  Image.asset(Assets.notFound, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            category.name,
            style: getSemiBoldStyle(
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
              color: color.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
