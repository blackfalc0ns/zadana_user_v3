import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/widgets/custom_vertical_filter_chip.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';

class FilterCategorySection extends StatefulWidget {
  const FilterCategorySection({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  @override
  State<FilterCategorySection> createState() => _FilterCategorySectionState();
}

class _FilterCategorySectionState extends State<FilterCategorySection> {
  bool showAllCategories = false;
  String? localSelectedCategory;

  @override
  void initState() {
    super.initState();
    localSelectedCategory = widget.selectedCategory;
  }

  @override
  void didUpdateWidget(FilterCategorySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCategory != oldWidget.selectedCategory) {
      localSelectedCategory = widget.selectedCategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedCategories = showAllCategories
        ? kCategoryList
        : kCategoryList.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الفئة',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: Spacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.9,
            crossAxisSpacing: Spacing.sm,
            mainAxisSpacing: Spacing.sm,
          ),
          itemCount: displayedCategories.length,
          itemBuilder: (context, index) {
            final category = displayedCategories[index];
            final isSelected = localSelectedCategory == category.name;

            return CustomVerticalFilterChip(
              label: category.name,
              icon: category.emoji,
              isSelected: isSelected,
              onTap: () {
                final newSelection = isSelected ? null : category.name;
                setState(() => localSelectedCategory = newSelection);
                widget.onCategorySelected(newSelection);
              },
            );
          },
        ),
        if (kCategoryList.length > 8)
          Transform.translate(
            offset: const Offset(0, -22),
            child: Center(
              child: TextButton(
                onPressed: () => setState(() => showAllCategories = !showAllCategories),
                child: Text(showAllCategories ? 'عرض أقل' : 'عرض المزيد'),
              ),
            ),
          ),
      ],
    );
  }
}
