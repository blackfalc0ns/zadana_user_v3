import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_vertical_filter_chip.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/gradient_section_title.dart';

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
    final locale = context.localization;
    final color = context.colorScheme;
    final displayedCategories = showAllCategories
        ? kCategoryList
        : kCategoryList.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientSectionTitle(title: locale.filter_category_title),
        const SizedBox(height: Spacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.0, // زيادة من 0.75 إلى 1.0 عشان الكارد بقى أقصر
            crossAxisSpacing: Spacing.sm,
            mainAxisSpacing: Spacing.sm,
          ),
          itemCount: displayedCategories.length,
          itemBuilder: (context, index) {
            final category = displayedCategories[index];
            final isSelected = localSelectedCategory == category.name;
            return _buildCategoryChip(context, category, isSelected);
          },
        ),
        if (kCategoryList.length > 4)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.md),
            child: Center(
              child: TextButton(
                onPressed: () => setState(() => showAllCategories = !showAllCategories),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      showAllCategories ? locale.show_less : locale.show_more,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16,
                        color: color.secondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      showAllCategories
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: color.secondary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryChip(BuildContext context, CategoryEntity category, bool isSelected) {
    final color = context.colorScheme;

    return CustomVerticalFilterChip(
      label: category.name,
      icon: category.emoji,
      isSelected: isSelected,
      onTap: () {
        final newSelection = isSelected ? null : category.name;
        setState(() {
          localSelectedCategory = newSelection;
        });
        widget.onCategorySelected(newSelection);
      },
      backgroundColor: color.surface,
      selectedColor: color.primary,
      borderColor: color.outline.withValues(alpha: 0.2),
      textStyle: getRegularStyle(
        color: isSelected ? color.onPrimary : color.onSurface,
        fontFamily: FontConstant.cairo,
        fontSize: FontSize.size12,
      ),
    );
  }
}
