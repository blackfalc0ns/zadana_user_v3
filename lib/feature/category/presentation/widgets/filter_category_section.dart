import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_vertical_filter_chip.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';

class FilterCategorySection extends StatefulWidget {
  const FilterCategorySection({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
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
    localSelectedCategory = widget.selectedCategoryId;
  }

  @override
  void didUpdateWidget(FilterCategorySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCategoryId != oldWidget.selectedCategoryId) {
      localSelectedCategory = widget.selectedCategoryId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final displayedCategories = showAllCategories
        ? widget.categories
        : widget.categories.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.filter_category_title,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            color: color.primary,
            fontSize: FontSize.size16,
          ),
        ),
        const SizedBox(height: Spacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final childAspectRatio = width < 360 ? 0.72 : 0.86;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: Spacing.sm,
                mainAxisSpacing: Spacing.sm,
              ),
              itemCount: displayedCategories.length,
              itemBuilder: (context, index) {
                final category = displayedCategories[index];
                final isSelected = localSelectedCategory == category.id;

                return CustomVerticalFilterChip(
                  label: category.name,
                  icon: category.emoji,
                  isSelected: isSelected,
                  onTap: () {
                    final newSelection = isSelected ? null : category.id;
                    setState(() => localSelectedCategory = newSelection);
                    widget.onCategorySelected(newSelection);
                  },
                );
              },
            );
          },
        ),
        if (widget.categories.length > 8)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.xs),
            child: Center(
              child: TextButton(
                onPressed: () =>
                    setState(() => showAllCategories = !showAllCategories),
                child: Text(
                  showAllCategories ? locale.show_less : locale.show_more,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
