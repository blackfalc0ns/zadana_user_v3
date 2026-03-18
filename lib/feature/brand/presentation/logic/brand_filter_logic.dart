import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_product_model.dart';
import 'package:zadana_user_v3/feature/brand/domain/enums/product_sort_option.dart';

class BrandFilterLogic {
  static List<String> extractCategories(List<BrandProductModel> products) {
    final categories = products
        .where((p) => p.category != null)
        .map((p) => p.category!)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  static List<String> extractUnits(List<BrandProductModel> products) {
    final units = products
        .where((p) => p.unit != null && p.unit!.isNotEmpty)
        .map((p) => p.unit!)
        .toSet()
        .toList();
    units.sort();
    return units;
  }

  static List<String> extractSubcategories(List<BrandProductModel> products) {
    final subcategories = products
        .where((p) => p.subcategory != null && p.subcategory!.isNotEmpty)
        .map((p) => p.subcategory!)
        .toSet()
        .toList();
    subcategories.sort();
    return subcategories;
  }

  static List<String> getAvailableSubcategories(
    List<BrandProductModel> allProducts,
    String? selectedCategory,
  ) {
    final source = selectedCategory == null
        ? allProducts
        : allProducts.where((p) => p.category == selectedCategory).toList();
    return extractSubcategories(source);
  }

  static List<BrandProductModel> applyFilters({
    required List<BrandProductModel> products,
    String? selectedCategory,
    String? selectedSubcategory,
    required RangeValues priceRange,
    String? selectedUnit,
  }) {
    var filtered = List<BrandProductModel>.from(products);

    // Filter by category
    if (selectedCategory != null) {
      filtered = filtered.where((p) => p.category == selectedCategory).toList();
    }

    // Filter by subcategory
    if (selectedSubcategory != null) {
      filtered = filtered.where((p) => p.subcategory == selectedSubcategory).toList();
    }

    // Filter by price range
    filtered = filtered
        .where((p) => p.price >= priceRange.start && p.price <= priceRange.end)
        .toList();

    // Filter by unit
    if (selectedUnit != null) {
      filtered = filtered.where((p) => p.unit == selectedUnit).toList();
    }

    return filtered;
  }

  static List<BrandProductModel> sortProducts(
    List<BrandProductModel> products,
    ProductSortOption sortOption,
  ) {
    final sorted = List<BrandProductModel>.from(products);

    switch (sortOption) {
      case ProductSortOption.bestSellers:
        sorted.sort((a, b) {
          if (a.isBestSeller && !b.isBestSeller) return -1;
          if (!a.isBestSeller && b.isBestSeller) return 1;
          if (a.hasDiscount && !b.hasDiscount) return -1;
          if (!a.hasDiscount && b.hasDiscount) return 1;
          if (a.isInStock && !b.isInStock) return -1;
          if (!a.isInStock && b.isInStock) return 1;
          return 0;
        });
        break;
      case ProductSortOption.priceLowToHigh:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortOption.priceHighToLow:
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortOption.newest:
        sorted.sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return b.createdAt!.compareTo(a.createdAt!);
        });
        break;
    }

    return sorted;
  }
}
