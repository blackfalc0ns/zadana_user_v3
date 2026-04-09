import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_chip.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/shimmer_wrapper.dart';

class SubCategoryChips extends StatelessWidget {
  const SubCategoryChips({
    super.key,
    required this.subCategories,
    required this.selectedSubCategoryId,
    required this.onSubCategorySelected,
    this.isLoading = false,
  });

  final List<CategorySubcategoryItemDto> subCategories;
  final String? selectedSubCategoryId;
  final ValueChanged<CategorySubcategoryItemDto> onSubCategorySelected;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      isLoading: isLoading,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
          itemBuilder: (_, index) => _Bone(
            width: index == 0 ? 96 : 74,
            height: 36,
            radius: 999,
          ),
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        itemCount: subCategories.length,
        separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
        itemBuilder: (context, index) {
          final subCategory = subCategories[index];
          return CategoryChip(
            label: subCategory.name ?? '',
            emoji: '',
            isSelected: subCategory.id == selectedSubCategoryId,
            onTap: () => onSubCategorySelected(subCategory),
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
