import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_filter_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/brand_filter_bottom_sheet.dart';

class BrandFilterService {
  static Future<Map<String, dynamic>?> showFilterBottomSheet({
    required BuildContext context,
    required List<BrandFilterOptionDto> categories,
    required List<BrandFilterSubcategoryItemDto> subcategories,
    required List<String> units,
    required RangeValues currentPriceRange,
    required RangeValues priceBounds,
    required String? currentSelectedCategory,
    required String? currentSelectedSubcategory,
    required String? currentSelectedUnit,
  }) async {
    return await BrandFilterBottomSheet.show(
      context: context,
      categories: categories,
      subcategories: subcategories,
      units: units,
      currentPriceRange: currentPriceRange,
      priceBounds: priceBounds,
      currentSelectedCategory: currentSelectedCategory,
      currentSelectedSubcategory: currentSelectedSubcategory,
      currentSelectedUnit: currentSelectedUnit,
    );
  }
}
