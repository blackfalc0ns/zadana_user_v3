import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
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
          return Column(
            children: [
              SectionHeader(
                title: locale.categ,
                actionLabel: locale.see_all,
                onActionTap: () {},
              ),
              const SizedBox(height: Spacing.md),
              const _OfflineCategoriesSection(),
            ],
          );
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
              onActionTap: () {},
            ),
            const SizedBox(height: Spacing.md),
            SizedBox(
              height: 102,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
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

class _OfflineCategoriesSection extends StatelessWidget {
  const _OfflineCategoriesSection();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.lg,
        ),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.outline.withValues(alpha: 0.15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 34, color: color.primary),
            const SizedBox(height: Spacing.sm),
            Text(
              locale.offline_connection_issue_title,
              style: getSemiBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              locale.offline_connection_issue_message,
              style: getRegularStyle(
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
                color: color.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCategoryItem extends StatelessWidget {
  const _HomeCategoryItem({required this.category});

  final HomeCategoryItemEntity category;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: 76,
      margin: const EdgeInsetsDirectional.only(end: Spacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: color.outline.withValues(alpha: 0.2),
                width: .5,
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: category.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    Container(color: color.surfaceContainerHighest),
                errorWidget: (_, _, _) => Image.asset(
                  'assets/images/image_not_found.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            category.name,
            style: getRegularStyle(
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
              color: color.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
