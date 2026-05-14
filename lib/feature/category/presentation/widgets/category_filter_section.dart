import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_chip.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_brand_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_brand_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_category_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_option_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_price_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_quantity_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/gradient_section_title.dart';

class CategoryFilterSection extends StatelessWidget {
  const CategoryFilterSection({
    super.key,
    this.showCategorySection = true,
    this.categories = const [],
    this.subCategories = const [],
    this.quantities = const [],
    this.brands = const [],
    this.brandItems = const [],
    this.productTypes = const [],
    this.parts = const [],
    this.selectedCategoryId,
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

  final bool showCategorySection;
  final List<CategoryEntity> categories;
  final List<CategorySubcategoryItemDto> subCategories;
  final List<String> quantities;
  final List<String> brands;
  final List<CategoryFilterBrandItemDto> brandItems;
  final List<String> productTypes;
  final List<String> parts;
  final String? selectedCategoryId;
  final String? selectedSubCategoryId;
  final String? selectedQuantity;
  final String? selectedBrand;
  final String? selectedProductType;
  final String? selectedPart;
  final RangeValues priceRange;
  final RangeValues priceBounds;
  final Function(String?) onCategorySelected;
  final Function(CategorySubcategoryItemDto?) onSubCategorySelected;
  final Function(String?) onQuantitySelected;
  final Function(String?) onBrandSelected;
  final Function(String?) onProductTypeSelected;
  final Function(String?) onPartSelected;
  final Function(RangeValues) onPriceRangeChanged;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final sections = <Widget>[
      FilterPriceSection(
        priceRange: priceRange,
        priceBounds: priceBounds,
        onPriceRangeChanged: onPriceRangeChanged,
      ),
    ];

    if (showCategorySection) {
      sections.add(
        FilterCategorySection(
          categories: categories,
          selectedCategoryId: selectedCategoryId,
          onCategorySelected: (category) {
            onCategorySelected(category);
            onQuantitySelected(null);
            onBrandSelected(null);
            onProductTypeSelected(null);
            onPartSelected(null);
          },
        ),
      );

      if (subCategories.isNotEmpty && selectedCategoryId != null) {
        sections.add(
          _FilterSubCategorySection(
            subCategories: subCategories,
            selectedSubCategoryId: selectedSubCategoryId,
            onSubCategorySelected: onSubCategorySelected,
          ),
        );
      }
    }

    sections.addAll([
      FilterQuantitySection(
        quantities: quantities,
        selectedQuantity: selectedQuantity,
        onQuantitySelected: onQuantitySelected,
      ),
      FilterBrandSection(
        brands: brands,
        brandItems: brandItems,
        selectedBrand: selectedBrand,
        onBrandSelected: onBrandSelected,
      ),
      FilterOptionSection(
        title: locale.select_product_type,
        options: productTypes,
        selectedValue: selectedProductType,
        onOptionSelected: (value) {
          onProductTypeSelected(value);
          onPartSelected(null);
        },
      ),
      FilterOptionSection(
        title: locale.filter_part,
        options: parts,
        selectedValue: selectedPart,
        onOptionSelected: onPartSelected,
      ),
    ]);

    final visibleSections = sections.whereType<Widget>().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < visibleSections.length; i++) ...[
          visibleSections[i],
          if (i != visibleSections.length - 1)
            const SizedBox(height: Spacing.lg),
        ],
      ],
    );
  }
}

class _FilterSubCategorySection extends StatefulWidget {
  const _FilterSubCategorySection({
    required this.subCategories,
    required this.selectedSubCategoryId,
    required this.onSubCategorySelected,
  });

  final List<CategorySubcategoryItemDto> subCategories;
  final String? selectedSubCategoryId;
  final ValueChanged<CategorySubcategoryItemDto?> onSubCategorySelected;

  @override
  State<_FilterSubCategorySection> createState() =>
      _FilterSubCategorySectionState();
}

class _FilterSubCategorySectionState extends State<_FilterSubCategorySection> {
  String? localSelectedSubCategoryId;

  @override
  void initState() {
    super.initState();
    localSelectedSubCategoryId = widget.selectedSubCategoryId;
  }

  @override
  void didUpdateWidget(covariant _FilterSubCategorySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedSubCategoryId != oldWidget.selectedSubCategoryId ||
        widget.subCategories != oldWidget.subCategories) {
      localSelectedSubCategoryId = widget.selectedSubCategoryId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final validSubCategories = widget.subCategories
        .where((item) => (item.name ?? '').isNotEmpty)
        .toList();

    if (validSubCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientSectionTitle(title: locale.filter_subcategory_title),
        const SizedBox(height: Spacing.sm),
        Wrap(
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          children: validSubCategories.map((subCategory) {
            final name = subCategory.name?.trim() ?? '';
            final isSelected = localSelectedSubCategoryId == subCategory.id;

            return CustomFilterChip(
              label: name,
              imageUrl: subCategory.imageUrl,
              isSelected: isSelected,
              onTap: () {
                final newSelectionId = isSelected ? null : subCategory.id;
                setState(() => localSelectedSubCategoryId = newSelectionId);
                widget.onSubCategorySelected(
                  newSelectionId == null ? null : subCategory,
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
