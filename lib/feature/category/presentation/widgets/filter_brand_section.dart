import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_option_section.dart';

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

    return FilterOptionSection(
      title: context.localization.filter_brand,
      options: brands,
      selectedValue: localSelectedBrand,
      onOptionSelected: (brand) {
        setState(() => localSelectedBrand = brand);
        widget.onBrandSelected(brand);
      },
    );
  }
}
