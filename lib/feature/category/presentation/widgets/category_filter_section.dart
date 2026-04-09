import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_brand_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_category_section.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_price_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_quantity_section.dart';

class CategoryFilterSection extends StatelessWidget {
  final bool showCategorySection;
  final List<CategoryEntity> categories;
  final List<String> quantities;
  final List<String> brands;
  final String? selectedCategory;
  final String? selectedQuantity;
  final String? selectedBrand;
  final RangeValues priceRange;
  final Function(String?) onCategorySelected;
  final Function(String?) onQuantitySelected;
  final Function(String?) onBrandSelected;
  final Function(RangeValues) onPriceRangeChanged;

  const CategoryFilterSection({
    super.key,
    this.showCategorySection = true,
    this.categories = const [],
    this.quantities = const [],
    this.brands = const [],
    this.selectedCategory,
    this.selectedQuantity,
    this.selectedBrand,
    required this.priceRange,
    required this.onCategorySelected,
    required this.onQuantitySelected,
    required this.onBrandSelected,
    required this.onPriceRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final detailSections = <Widget>[
      FilterQuantitySection(
        quantities: quantities,
        selectedQuantity: selectedQuantity,
        onQuantitySelected: onQuantitySelected,
      ),
      FilterBrandSection(
        brands: brands,
        selectedBrand: selectedBrand,
        onBrandSelected: onBrandSelected,
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
            categories: categories,
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              onCategorySelected(category);
              onQuantitySelected(null);
              onBrandSelected(null);
            },
          ),
        ],
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
