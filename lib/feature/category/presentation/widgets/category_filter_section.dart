import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_chip.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_brand_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_measurement_option_dto.dart';
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
    this.packageTypes = const [],
    this.measurementUnits = const [],
    this.measurementValues = const [],
    this.measurementOptions = const [],
    this.selectedCategoryId,
    this.selectedSubCategoryId,
    this.selectedQuantity,
    this.selectedBrand,
    this.selectedProductType,
    this.selectedPart,
    this.selectedPackageType,
    this.selectedMeasurementUnit,
    this.selectedMeasurementValue,
    required this.priceRange,
    required this.priceBounds,
    required this.onCategorySelected,
    required this.onSubCategorySelected,
    required this.onQuantitySelected,
    required this.onBrandSelected,
    required this.onProductTypeSelected,
    required this.onPartSelected,
    required this.onPriceRangeChanged,
    this.onPackageTypeSelected,
    this.onMeasurementUnitSelected,
    this.onMeasurementValueSelected,
    this.onLoadMoreCategories,
    this.isLoadingMoreCategories = false,
    this.hasMoreCategories = true,
  });

  final bool showCategorySection;
  final List<CategoryEntity> categories;
  final List<CategorySubcategoryItemDto> subCategories;
  final List<String> quantities;
  final List<String> brands;
  final List<CategoryFilterBrandItemDto> brandItems;
  final List<String> productTypes;
  final List<String> parts;
  final List<String> packageTypes;
  final List<String> measurementUnits;
  final List<double> measurementValues;
  final List<CategoryMeasurementOptionDto> measurementOptions;
  final String? selectedCategoryId;
  final String? selectedSubCategoryId;
  final String? selectedQuantity;
  final String? selectedBrand;
  final String? selectedProductType;
  final String? selectedPart;
  final String? selectedPackageType;
  final String? selectedMeasurementUnit;
  final double? selectedMeasurementValue;
  final RangeValues priceRange;
  final RangeValues priceBounds;
  final Function(String?) onCategorySelected;
  final Function(CategorySubcategoryItemDto?) onSubCategorySelected;
  final Function(String?) onQuantitySelected;
  final Function(String?) onBrandSelected;
  final Function(String?) onProductTypeSelected;
  final Function(String?) onPartSelected;
  final Function(RangeValues) onPriceRangeChanged;
  final Function(String?)? onPackageTypeSelected;
  final Function(String?)? onMeasurementUnitSelected;
  final Function(double?)? onMeasurementValueSelected;
  final VoidCallback? onLoadMoreCategories;
  final bool isLoadingMoreCategories;
  final bool hasMoreCategories;

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
          onLoadMore: onLoadMoreCategories,
          isLoadingMore: isLoadingMoreCategories,
          hasMore: hasMoreCategories,
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
      if (packageTypes.isNotEmpty && onPackageTypeSelected != null)
        FilterOptionSection(
          title: locale.brand_filter_package_type_title,
          options: packageTypes,
          selectedValue: selectedPackageType,
          onOptionSelected: onPackageTypeSelected!,
        ),
      if (measurementUnits.isNotEmpty && onMeasurementUnitSelected != null)
        FilterOptionSection(
          title: locale.brand_filter_measurement_unit_title,
          options: measurementUnits,
          selectedValue: selectedMeasurementUnit,
          onOptionSelected: onMeasurementUnitSelected!,
        ),
      if (measurementOptions.isNotEmpty && onMeasurementValueSelected != null)
        FilterOptionSection(
          title: locale.brand_filter_measurement_value_title,
          options: measurementOptions
              .map((o) => o.label ?? '')
              .where((l) => l.isNotEmpty)
              .toList(growable: false),
          selectedValue: selectedMeasurementValue != null
              ? measurementOptions
                    .where(
                      (o) => o.measurementValue == selectedMeasurementValue,
                    )
                    .firstOrNull
                    ?.label
              : null,
          onOptionSelected: (value) {
            if (value == null) {
              onMeasurementValueSelected!(null);
            } else {
              final option = measurementOptions.firstWhere(
                (o) => o.label == value,
                orElse: () => const CategoryMeasurementOptionDto(),
              );
              onMeasurementValueSelected!(option.measurementValue);
            }
          },
        )
      else if (measurementValues.isNotEmpty &&
          onMeasurementValueSelected != null)
        FilterOptionSection(
          title: locale.brand_filter_measurement_value_title,
          options: measurementValues.map(_formatMeasurementValue).toList(
            growable: false,
          ),
          selectedValue: selectedMeasurementValue != null
              ? _formatMeasurementValue(selectedMeasurementValue!)
              : null,
          onOptionSelected: (value) {
            if (value == null) {
              onMeasurementValueSelected!(null);
            } else {
              final index = measurementValues
                  .map(_formatMeasurementValue)
                  .toList()
                  .indexOf(value);
              if (index >= 0) {
                onMeasurementValueSelected!(measurementValues[index]);
              }
            }
          },
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

  static String _formatMeasurementValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
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
