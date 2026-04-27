import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_option_entity.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_filter_subcategory_entity.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand_details/widgets/brand_filter_sections.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand_details/widgets/subcategory_filter_section.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand_details/widgets/unit_filter_section.dart';

class BrandFilterBottomSheet {
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required List<BrandFilterOptionEntity> categories,
    required List<BrandFilterSubcategoryEntity> subcategories,
    required List<String> units,
    required RangeValues currentPriceRange,
    required RangeValues priceBounds,
    required String? currentSelectedCategory,
    required String? currentSelectedSubcategory,
    required String? currentSelectedUnit,
  }) {
    final tempPriceRange = ValueNotifier(currentPriceRange);
    final tempSelectedCategory = ValueNotifier<String?>(
      currentSelectedCategory,
    );
    final tempSelectedSubcategory = ValueNotifier<String?>(
      currentSelectedSubcategory,
    );
    final tempSelectedUnit = ValueNotifier<String?>(currentSelectedUnit);
    final sheetScrollController = ScrollController();

    void scrollSheetTo(double offset) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!sheetScrollController.hasClients) {
          return;
        }
        final target = (sheetScrollController.offset + offset).clamp(
          0.0,
          sheetScrollController.position.maxScrollExtent,
        );
        sheetScrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        );
      });
    }

    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ListenableBuilder(
        listenable: Listenable.merge([
          tempPriceRange,
          tempSelectedCategory,
          tempSelectedSubcategory,
          tempSelectedUnit,
        ]),
        builder: (context, _) => CustomFilterBottomSheet(
          title: context.localization.filter_title,
          cancelLabel: context.localization.cancel,
          clearAllLabel: context.localization.clear_all,
          applyLabel: context.localization.apply,
          scrollController: sheetScrollController,
          children: [
            PriceRangeSection(
              priceRange: tempPriceRange.value,
              priceBounds: priceBounds,
              onChanged: (values) => tempPriceRange.value = values,
            ),
            const SizedBox(height: 8),
            CategoryFilterSection(
              categories: categories
                  .where((item) => item.name.trim().isNotEmpty)
                  .toList(growable: false),
              selectedCategory: tempSelectedCategory.value,
              onCategoryChanged: (category) {
                tempSelectedCategory.value = category;
                tempSelectedSubcategory.value = null;
                if (category != null) {
                  scrollSheetTo(170);
                }
              },
            ),
            const SizedBox(height: 8),
            SubcategoryFilterSection(
              categories: categories,
              subcategories: subcategories,
              selectedCategory: tempSelectedCategory.value,
              selectedSubcategory: tempSelectedSubcategory.value,
              onSubcategoryChanged: (subcategory) {
                tempSelectedSubcategory.value = subcategory;
                if (subcategory != null) {
                  scrollSheetTo(130);
                }
              },
            ),
            const SizedBox(height: 8),
            UnitFilterSection(
              units: units,
              selectedUnit: tempSelectedUnit.value,
              onUnitChanged: (unit) => tempSelectedUnit.value = unit,
            ),
          ],
          onApply: () => Navigator.pop(context, {
            'category': tempSelectedCategory.value,
            'subcategory': tempSelectedSubcategory.value,
            'priceRange': tempPriceRange.value,
            'unit': tempSelectedUnit.value,
          }),
          onClearAll: () {
            tempSelectedCategory.value = null;
            tempSelectedSubcategory.value = null;
            tempPriceRange.value = priceBounds;
            tempSelectedUnit.value = null;
          },
        ),
      ),
    );
  }
}
