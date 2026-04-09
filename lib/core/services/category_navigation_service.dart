import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';

/// Service to manage moving from home categories to the shopping tab.
class CategoryNavigationService extends ChangeNotifier {
  static final CategoryNavigationService _instance =
      CategoryNavigationService._internal();

  factory CategoryNavigationService() => _instance;

  CategoryNavigationService._internal();

  CategoryEntity? _selectedCategory;

  /// The category selected from the home screen.
  CategoryEntity? get selectedCategory => _selectedCategory;

  /// Update the selected category.
  void setSelectedCategory(CategoryEntity category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Clear the selected category.
  void clearSelectedCategory() {
    _selectedCategory = null;
    notifyListeners();
  }

  /// Notify listeners when the tab changes.
  void notifyTabChanged() {
    notifyListeners();
  }

  /// Returns the category name that should appear on CategoryScreen.
  String? getCategoryNameForScreen() {
    if (_selectedCategory == null) return null;

    if (_selectedCategory!.name.isNotEmpty) {
      return _selectedCategory!.name;
    }

    switch (_selectedCategory!.id) {
      case 'cat1':
        return 'خضروات';
      case 'cat5':
        return 'ألبان';
      case 'cat6':
        return 'مخبوزات';
      case 'cat3':
        return 'لحوم';
      case 'cat7':
        return 'مشروبات';
      case 'cat8':
        return 'منزلية';
      case 'cat9':
        return 'عناية';
      case 'cat10':
        return 'سناكس';
      default:
        return null;
    }
  }
}
