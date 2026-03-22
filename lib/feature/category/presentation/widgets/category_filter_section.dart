import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_animal_type_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_category_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_meat_part_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_price_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_quantity_section.dart';

class CategoryFilterSection extends StatelessWidget {
  final bool showCategorySection;
  final String? selectedCategory;
  final String? selectedProductType;
  final String? selectedPart;
  final String? selectedQuantity;
  final RangeValues priceRange;
  final Function(String?) onCategorySelected;
  final Function(String?) onProductTypeSelected;
  final Function(String?) onPartSelected;
  final Function(String?) onQuantitySelected;
  final Function(RangeValues) onPriceRangeChanged;

  const CategoryFilterSection({
    super.key,
    this.showCategorySection = true,
    this.selectedCategory,
    this.selectedProductType,
    this.selectedPart,
    this.selectedQuantity,
    required this.priceRange,
    required this.onCategorySelected,
    required this.onProductTypeSelected,
    required this.onPartSelected,
    required this.onQuantitySelected,
    required this.onPriceRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final detailSections = <Widget>[
      FilterAnimalTypeSection(
        selectedCategory: selectedCategory,
        selectedProductType: selectedProductType,
        onProductTypeSelected: (type) {
          onProductTypeSelected(type);
          onPartSelected(null);
        },
      ),
      FilterMeatPartSection(
        selectedCategory: selectedCategory,
        selectedProductType: selectedProductType,
        selectedPart: selectedPart,
        onPartSelected: onPartSelected,
      ),
      FilterQuantitySection(
        selectedCategory: selectedCategory,
        selectedQuantity: selectedQuantity,
        onQuantitySelected: onQuantitySelected,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterPriceSection(
          priceRange: priceRange,
          onPriceRangeChanged: onPriceRangeChanged,
        ),
        if (showCategorySection) ...[
          const SizedBox(height: Spacing.sm),
          FilterCategorySection(
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              onCategorySelected(category);
              onProductTypeSelected(null);
              onPartSelected(null);
              onQuantitySelected(null);
            },
          ),
        ],
        const SizedBox(height: Spacing.sm),
        ..._withSpacing(detailSections),
      ],
    );
  }

  List<Widget> _withSpacing(List<Widget> sections) {
    final widgets = <Widget>[];
    for (var i = 0; i < sections.length; i++) {
      widgets.add(sections[i]);
      if (i != sections.length - 1) {
        widgets.add(const SizedBox(height: Spacing.sm));
      }
    }
    return widgets;
  }
}
