import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_filter_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_option_grid.dart';

class SubcategoryFilterSection extends StatefulWidget {
  const SubcategoryFilterSection({
    super.key,
    required this.categories,
    required this.subcategories,
    required this.selectedCategory,
    required this.selectedSubcategory,
    required this.onSubcategoryChanged,
  });

  final List<BrandFilterOptionDto> categories;
  final List<BrandFilterSubcategoryItemDto> subcategories;
  final String? selectedCategory;
  final String? selectedSubcategory;
  final ValueChanged<String?> onSubcategoryChanged;

  @override
  State<SubcategoryFilterSection> createState() =>
      _SubcategoryFilterSectionState();
}

class _SubcategoryFilterSectionState extends State<SubcategoryFilterSection> {
  String? localSelectedSubcategory;

  @override
  void initState() {
    super.initState();
    localSelectedSubcategory = widget.selectedSubcategory;
  }

  @override
  void didUpdateWidget(SubcategoryFilterSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedSubcategory != oldWidget.selectedSubcategory) {
      localSelectedSubcategory = widget.selectedSubcategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedCategory == null) {
      return const SizedBox.shrink();
    }

    final selectedCategoryId = widget.categories
        .firstWhere(
          (item) => item.name == widget.selectedCategory,
          orElse: () => const BrandFilterOptionDto(),
        )
        .id;

    final availableSubcategories = widget.subcategories
        .where(
          (item) =>
              selectedCategoryId == null ||
              selectedCategoryId.isEmpty ||
              item.categoryId == selectedCategoryId,
        )
        .map((item) => item.name?.trim() ?? '')
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    if (availableSubcategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'النوع',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: Spacing.md),
        FilterOptionGrid(
          options: availableSubcategories,
          selectedValue: localSelectedSubcategory,
          onOptionTap: (subcategory) {
            final newSelection =
                localSelectedSubcategory == subcategory ? null : subcategory;
            setState(() => localSelectedSubcategory = newSelection);
            widget.onSubcategoryChanged(newSelection);
          },
        ),
      ],
    );
  }
}
