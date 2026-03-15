import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_sheet_header.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_category_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_price_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_animal_type_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_meat_part_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_quantity_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_apply_button.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key, this.preSelectedCategory});
  final String? preSelectedCategory;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? selectedCategory;
  String? selectedProductType;
  String? selectedPart;
  String? selectedQuantity;
  RangeValues priceRange = const RangeValues(0, 1000);

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedCategory != null &&
        kCategorySubCategories.containsKey(widget.preSelectedCategory)) {
      selectedCategory = widget.preSelectedCategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              FilterSheetHeader(
                onCancel: () => Navigator.pop(context),
                onClearAll: () => setState(() {
                  selectedCategory = null;
                  selectedProductType = null;
                  selectedPart = null;
                  selectedQuantity = null;
                  priceRange = const RangeValues(0, 1000);
                }),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
                  children: [
                    FilterPriceSection(
                      priceRange: priceRange,
                      onPriceRangeChanged: (values) =>
                          setState(() => priceRange = values),
                    ),
                    const SizedBox(height: Spacing.base),
                    FilterCategorySection(
                      selectedCategory: selectedCategory,
                      onCategorySelected: (category) => setState(() {
                        selectedCategory = category;
                        selectedProductType = null;
                        selectedPart = null;
                      }),
                    ),
                    FilterAnimalTypeSection(
                      selectedCategory: selectedCategory,
                      selectedProductType: selectedProductType,
                      onProductTypeSelected: (type) => setState(() {
                        selectedProductType = type;
                        selectedPart = null;
                      }),
                    ),
                    const SizedBox(height: Spacing.base),
                    FilterMeatPartSection(
                      selectedCategory: selectedCategory,
                      selectedProductType: selectedProductType,
                      selectedPart: selectedPart,
                      onPartSelected: (part) =>
                          setState(() => selectedPart = part),
                    ),

                    if (selectedPart != null)
                      const SizedBox(height: Spacing.base),

                    FilterQuantitySection(
                      selectedCategory: selectedCategory,
                      selectedQuantity: selectedQuantity,
                      onQuantitySelected: (quantity) =>
                          setState(() => selectedQuantity = quantity),
                    ),
                    const SizedBox(height: 120), // مساحة للزرار
                  ],
                ),
              ),
            ],
          ),
          FilterApplyButton(
            onApply: () => Navigator.pop(context, {
              'category': selectedCategory,
              'productType': selectedProductType,
              'part': selectedPart,
              'quantity': selectedQuantity,
              'priceRange': priceRange,
            }),
          ),
        ],
      ),
    );
  }
}
