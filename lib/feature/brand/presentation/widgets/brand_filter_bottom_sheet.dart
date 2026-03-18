import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/brand_filter_sections.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/subcategory_filter_section.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/unit_filter_section.dart';

class BrandFilterBottomSheet {
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required List<BrandProductModel> allProducts,
    required List<String> categories,
    required List<String> units,
    required RangeValues currentPriceRange,
    required String? currentSelectedCategory,
    required String? currentSelectedSubcategory,
    required String? currentSelectedUnit,
  }) {
    RangeValues tempPriceRange = currentPriceRange;
    String? tempSelectedCategory = currentSelectedCategory;
    String? tempSelectedSubcategory = currentSelectedSubcategory;
    String? tempSelectedUnit = currentSelectedUnit;

    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => CustomFilterBottomSheet(
          title: 'فلتر المنتجات',
          children: [
            PriceRangeSection(
              priceRange: tempPriceRange,
              onChanged: (values) => setModalState(() => tempPriceRange = values),
            ),
            const SizedBox(height: 24),

            CategoryFilterSection(
              categories: categories,
              selectedCategory: tempSelectedCategory,
              onCategoryChanged: (category) => setModalState(() {
                tempSelectedCategory = category;
                if (tempSelectedSubcategory != null) {
                  final availableSubcategories = allProducts
                      .where((p) => p.category == category)
                      .map((p) => p.subcategory)
                      .where((s) => s != null)
                      .cast<String>()
                      .toSet()
                      .toList();
                  if (!availableSubcategories.contains(tempSelectedSubcategory)) {
                    tempSelectedSubcategory = null;
                  }
                }
              }),
            ),
            const SizedBox(height: 24),

            SubcategoryFilterSection(
              allProducts: allProducts,
              selectedCategory: tempSelectedCategory,
              selectedSubcategory: tempSelectedSubcategory,
              onSubcategoryChanged: (subcategory) => setModalState(() => tempSelectedSubcategory = subcategory),
            ),
            const SizedBox(height: 24),

            UnitFilterSection(
              units: units,
              selectedUnit: tempSelectedUnit,
              onUnitChanged: (unit) => setModalState(() => tempSelectedUnit = unit),
            ),
          ],
          onApply: () => Navigator.pop(context, {
            'category': tempSelectedCategory,
            'subcategory': tempSelectedSubcategory,
            'priceRange': tempPriceRange,
            'unit': tempSelectedUnit,
          }),
          onClearAll: () => setModalState(() {
            tempSelectedCategory = null;
            tempSelectedSubcategory = null;
            tempPriceRange = const RangeValues(0, 500);
            tempSelectedUnit = null;
          }),
        ),
      ),
    );
  }
}