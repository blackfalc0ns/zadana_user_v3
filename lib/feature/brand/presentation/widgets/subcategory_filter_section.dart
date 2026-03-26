import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_option_grid.dart';

class SubcategoryFilterSection extends StatefulWidget {
  const SubcategoryFilterSection({
    super.key,
    required this.allProducts,
    required this.selectedCategory,
    required this.selectedSubcategory,
    required this.onSubcategoryChanged,
  });

  final List<BrandProductModel> allProducts;
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

    final availableSubcategories = widget.allProducts
        .where((p) => p.category == widget.selectedCategory)
        .map((p) => p.subcategory)
        .where((s) => s != null && s!.isNotEmpty)
        .cast<String>()
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
