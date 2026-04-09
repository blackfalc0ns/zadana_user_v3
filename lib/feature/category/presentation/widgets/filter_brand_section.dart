import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/widgets/custom_vertical_filter_chip.dart';

class FilterBrandSection extends StatefulWidget {
  const FilterBrandSection({
    super.key,
    required this.brands,
    required this.selectedBrand,
    required this.onBrandSelected,
  });

  final List<String> brands;
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
    final brands = widget.brands;
    if (brands.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'البراند',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: Spacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final childAspectRatio = width < 360 ? 0.92 : 1.08;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: Spacing.sm,
                mainAxisSpacing: Spacing.sm,
              ),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                final logo = brand.isNotEmpty ? brand.substring(0, 1) : null;
                final isSelected = localSelectedBrand == brand;

                return CustomVerticalFilterChip(
                  label: brand,
                  icon: logo,
                  isSelected: isSelected,
                  onTap: () {
                    final newSelection = isSelected ? null : brand;
                    setState(() => localSelectedBrand = newSelection);
                    widget.onBrandSelected(newSelection);
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
