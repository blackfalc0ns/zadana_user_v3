import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_vertical_filter_chip.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_brand_item_dto.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/gradient_section_title.dart';

class FilterBrandSection extends StatefulWidget {
  const FilterBrandSection({
    super.key,
    required this.brands,
    required this.selectedBrand,
    required this.onBrandSelected,
    this.brandItems = const [],
  });

  /// Brand names (used as fallback if brandItems is empty).
  final List<String> brands;

  /// Full brand objects with logoUrl for image display.
  final List<CategoryFilterBrandItemDto> brandItems;

  final String? selectedBrand;
  final Function(String?) onBrandSelected;

  @override
  State<FilterBrandSection> createState() => _FilterBrandSectionState();
}

class _FilterBrandSectionState extends State<FilterBrandSection> {
  String? localSelectedBrand;

  @override
  void initState() {
    super.initState();
    localSelectedBrand = widget.selectedBrand;
  }

  @override
  void didUpdateWidget(FilterBrandSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedBrand != oldWidget.selectedBrand ||
        widget.brands != oldWidget.brands) {
      localSelectedBrand = widget.selectedBrand;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasBrandItems = widget.brandItems.isNotEmpty;
    final hasNames = widget.brands.isNotEmpty;

    if (!hasBrandItems && !hasNames) {
      return const SizedBox.shrink();
    }

    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientSectionTitle(title: context.localization.filter_brand),
        const SizedBox(height: Spacing.sm),
        if (hasBrandItems)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              crossAxisSpacing: Spacing.sm,
              mainAxisSpacing: Spacing.sm,
            ),
            itemCount: widget.brandItems.length,
            itemBuilder: (context, index) {
              final brand = widget.brandItems[index];
              final name = brand.name?.trim() ?? '';
              final isSelected = localSelectedBrand == name;

              return CustomVerticalFilterChip(
                label: name,
                imageUrl: brand.logoUrl,
                isSelected: isSelected,
                selectedColor: color.primary,
                onTap: () {
                  final newValue = isSelected ? null : name;
                  setState(() => localSelectedBrand = newValue);
                  widget.onBrandSelected(newValue);
                },
              );
            },
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              crossAxisSpacing: Spacing.sm,
              mainAxisSpacing: Spacing.sm,
            ),
            itemCount: widget.brands.length,
            itemBuilder: (context, index) {
              final name = widget.brands[index];
              final isSelected = localSelectedBrand == name;

              return CustomVerticalFilterChip(
                label: name,
                isSelected: isSelected,
                selectedColor: color.primary,
                onTap: () {
                  final newValue = isSelected ? null : name;
                  setState(() => localSelectedBrand = newValue);
                  widget.onBrandSelected(newValue);
                },
              );
            },
          ),
      ],
    );
  }
}
