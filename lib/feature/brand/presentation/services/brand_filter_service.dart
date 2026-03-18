import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';
import 'package:zadana_user_v3/feature/brand/presentation/widgets/brand_filter_bottom_sheet.dart';

class BrandFilterService {
  static Future<Map<String, dynamic>?> showFilterBottomSheet({
    required BuildContext context,
    required List<BrandProductModel> allProducts,
    required List<String> categories,
    required List<String> units,
    required RangeValues currentPriceRange,
    required String? currentSelectedCategory,
    required String? currentSelectedSubcategory,
    required String? currentSelectedUnit,
  }) async {
    return await BrandFilterBottomSheet.show(
      context: context,
      allProducts: allProducts,
      categories: categories,
      units: units,
      currentPriceRange: currentPriceRange,
      currentSelectedCategory: currentSelectedCategory,
      currentSelectedSubcategory: currentSelectedSubcategory,
      currentSelectedUnit: currentSelectedUnit,
    );
  }
}