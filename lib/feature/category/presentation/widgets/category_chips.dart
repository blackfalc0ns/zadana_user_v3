import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_chip.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/shimmer_wrapper.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.isLoading = false,
  });

  final List<CategoryEntity> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      isLoading: isLoading,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
          itemBuilder: (_, index) => _Bone(width: index == 0 ? 88 : 78, height: 36, radius: 999),
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: Spacing.sm),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category.name == selectedCategory;

          return CategoryChip(
            label: category.name,
            emoji: category.emoji,
            isSelected: isSelected,
            onTap: () => onCategorySelected(category.name),
          );
        },
      ),
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
