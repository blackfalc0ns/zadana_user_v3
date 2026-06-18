import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/widgets/skeleton_colors.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_chip.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart'
    show ShimmerEffect;

class SubCategoryChips extends StatelessWidget {
  const SubCategoryChips({
    super.key,
    required this.subCategories,
    required this.selectedSubCategoryId,
    required this.onSubCategorySelected,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.onLoadMore,
  });

  final List<CategorySubcategoryItemDto> subCategories;
  final String? selectedSubCategoryId;
  final ValueChanged<CategorySubcategoryItemDto> onSubCategorySelected;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _SubCategoryChipsSkeleton();
    }

    return SizedBox(
      height: 40,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              hasMore &&
              !isLoadingMore &&
              onLoadMore != null) {
            final metrics = notification.metrics;
            if (metrics.extentAfter < 100) {
              onLoadMore!();
            }
          }
          return false;
        },
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: Spacing.xs, right: Spacing.md),
          itemCount: subCategories.length + (isLoadingMore ? 1 : 0),
          separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
          itemBuilder: (context, index) {
            if (index >= subCategories.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
            final subCategory = subCategories[index];
            return CategoryChip(
              label: subCategory.name ?? '',
              imageUrl: subCategory.imageUrl,
              emoji: '',
              isSelected: subCategory.id == selectedSubCategoryId,
              onTap: () => onSubCategorySelected(subCategory),
            );
          },
        ),
      ),
    );
  }
}

class _SubCategoryChipsSkeleton extends StatelessWidget {
  const _SubCategoryChipsSkeleton();

  @override
  Widget build(BuildContext context) {
    final baseColor = SkeletonColors.base(context);
    return SizedBox(
      height: 40,
      child: ShimmerEffect(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: Spacing.xs, right: Spacing.md),
          itemCount: 7,
          separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
          itemBuilder: (_, index) => Container(
            width: 64 + ((index % 4) * 10),
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    );
  }
}
