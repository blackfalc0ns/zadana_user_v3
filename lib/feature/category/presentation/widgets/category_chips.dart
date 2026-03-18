import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_chip.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
   
  });

  final String selectedCategory;
  final Function(String) onCategorySelected;
  

  @override
  Widget build(BuildContext context) {
    final categories = kCategoryList;
    
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