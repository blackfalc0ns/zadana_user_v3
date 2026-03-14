import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_item.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({
    super.key,
    required this.categories,
    this.onCategoryTap,
    this.circleSize = 64,
  });

  final List<CategoryEntity> categories;
  final void Function(CategoryEntity)? onCategoryTap;
  final double circleSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: circleSize + 38,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, i) => CategoryItem(
          category: categories[i],
          size: circleSize,
          onTap: () => onCategoryTap?.call(categories[i]),
        ),
      ),
    );
  }
}