import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_brand_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_category_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_option_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_price_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_quantity_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/sub_category_chips.dart';

class CategoryFilterSection extends StatelessWidget {
  final bool showCategorySection;
  final List<CategoryEntity> categories;
  final List<CategorySubcategoryItemDto> subCategories;
  final List<String> quantities;
  final List<String> brands;
  final List<String> productTypes;
  final List<String> parts;
  final String? selectedCategory;
  final String? selectedSubCategoryId;
  final String? selectedQuantity;
  final String? selectedBrand;
  final String? selectedProductType;
  final String? selectedPart;
  final RangeValues priceRange;
  final RangeValues priceBounds;
  final Function(String?) onCategorySelected;
  final Function(CategorySubcategoryItemDto) onSubCategorySelected;
  final Function(String?) onQuantitySelected;
  final Function(String?) onBrandSelected;
  final Function(String?) onProductTypeSelected;
  final Function(String?) onPartSelected;
  final Function(RangeValues) onPriceRangeChanged;

  const CategoryFilterSection({
    super.key,
    this.showCategorySection = true,
    this.categories = const [],
    this.subCategories = const [],
    this.quantities = const [],
    this.brands = const [],
    this.productTypes = const [],
    this.parts = const [],
    this.selectedCategory,
    this.selectedSubCategoryId,
    this.selectedQuantity,
    this.selectedBrand,
    this.selectedProductType,
    this.selectedPart,
    required this.priceRange,
    required this.priceBounds,
    required this.onCategorySelected,
    required this.onSubCategorySelected,
    required this.onQuantitySelected,
    required this.onBrandSelected,
    required this.onProductTypeSelected,
    required this.onPartSelected,
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
      FilterOptionSection(
        title: 'نوع المنتج',
        options: productTypes,
        selectedValue: selectedProductType,
        onOptionSelected: (value) {
          onProductTypeSelected(value);
          onPartSelected(null);
        },
      ),
      FilterOptionSection(
        title: 'الجزء',
        options: parts,
        selectedValue: selectedPart,
        onOptionSelected: onPartSelected,
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
          priceBounds: priceBounds,
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
              onProductTypeSelected(null);
              onPartSelected(null);
            },
          ),
          if (subCategories.isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            _FilterSubCategorySection(
              subCategories: subCategories,
              selectedSubCategoryId: selectedSubCategoryId,
              onSubCategorySelected: onSubCategorySelected,
            ),
          ],
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

class _FilterSubCategorySection extends StatelessWidget {
  const _FilterSubCategorySection({
    required this.subCategories,
    required this.selectedSubCategoryId,
    required this.onSubCategorySelected,
  });

  final List<CategorySubcategoryItemDto> subCategories;
  final String? selectedSubCategoryId;
  final ValueChanged<CategorySubcategoryItemDto> onSubCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الفئة الفرعية',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: Spacing.sm),
        SubCategoryChips(
          subCategories: subCategories,
          selectedSubCategoryId: selectedSubCategoryId,
          onSubCategorySelected: onSubCategorySelected,
        ),
      ],
    );
  }
}
