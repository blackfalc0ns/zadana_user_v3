import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_option_grid.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/gradient_section_title.dart';

class FilterAnimalTypeSection extends StatefulWidget {
  const FilterAnimalTypeSection({
    super.key,
    required this.selectedCategory,
    required this.selectedProductType,
    required this.onProductTypeSelected,
  });

  final String? selectedCategory;
  final String? selectedProductType;
  final Function(String?) onProductTypeSelected;

  @override
  State<FilterAnimalTypeSection> createState() =>
      _FilterAnimalTypeSectionState();
}

class _FilterAnimalTypeSectionState extends State<FilterAnimalTypeSection> {
  String? localSelectedProductType;

  @override
  void initState() {
    super.initState();
    localSelectedProductType = widget.selectedProductType;
  }

  @override
  void didUpdateWidget(FilterAnimalTypeSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedProductType != oldWidget.selectedProductType) {
      localSelectedProductType = widget.selectedProductType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    if (widget.selectedCategory == null ||
        !kProductTypes.containsKey(widget.selectedCategory)) {
      return const SizedBox.shrink();
    }

    final productTypes = kProductTypes[widget.selectedCategory!] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientSectionTitle(title: locale.filter_type),
       const SizedBox(height: Spacing.sm),
        FilterOptionGrid(
          options: productTypes,
          selectedValue: localSelectedProductType,
          onOptionTap: (type) {
            final newSelection = localSelectedProductType == type ? null : type;
            setState(() {
              localSelectedProductType = newSelection;
            });
            widget.onProductTypeSelected(newSelection);
          },
        ),
      ],
    );
  }
}
