import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/widgets/custom_vertical_filter_chip.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/brand/data/mock_brand_products.dart';

class FilterBrandSection extends StatefulWidget {
  const FilterBrandSection({
    super.key,
    required this.selectedCategory,
    required this.selectedBrand,
    required this.onBrandSelected,
  });

  final String? selectedCategory;
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
        widget.selectedCategory != oldWidget.selectedCategory) {
      localSelectedBrand = widget.selectedBrand;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedCategory == null) {
      return const SizedBox.shrink();
    }

    final brands = getBrandsForCategory(widget.selectedCategory!);
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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.1,
            crossAxisSpacing: Spacing.sm,
            mainAxisSpacing: Spacing.sm,
          ),
          itemCount: brands.length,
          itemBuilder: (context, index) {
            final brand = brands[index];
            final products = MockBrandProducts.getProducts(brand, brand);
            final logo = products.isNotEmpty ? products.first.emoji : null;
            final isSelected = localSelectedBrand == brand;

            return CustomVerticalFilterChip(
              label:
              brand,
              icon: logo,
              isSelected: isSelected,
              onTap: () {
                final newSelection = isSelected ? null : brand;
                setState(() {
                  localSelectedBrand = newSelection;
                });
                widget.onBrandSelected(newSelection);
              },
            );
          },
        ),
      ],
    );
  }
}
