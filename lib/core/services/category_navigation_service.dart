import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';

/// Service to manage moving from home categories to the shopping tab.
class CategoryNavigationService extends ChangeNotifier {
  factory CategoryNavigationService() => _instance;

  CategoryNavigationService._internal();

  static final CategoryNavigationService _instance =
      CategoryNavigationService._internal();

  CategoryEntity? _selectedCategory;
  bool _shouldResetToDefault = false;
  bool _hasPendingExternalSelection = false;

  /// The category selected from the home screen.
  CategoryEntity? get selectedCategory => _selectedCategory;

  bool consumePendingExternalSelection() {
    final hasPendingExternalSelection = _hasPendingExternalSelection;
    _hasPendingExternalSelection = false;
    return hasPendingExternalSelection;
  }

  /// Update the selected category.
  void setSelectedCategory(CategoryEntity category) {
    _selectedCategory = category;
    _shouldResetToDefault = false;
    _hasPendingExternalSelection = true;
    notifyListeners();
  }

  /// Clear the selected category.
  void clearSelectedCategory() {
    _selectedCategory = null;
    notifyListeners();
  }

  /// Notify listeners when the tab changes.
  void notifyTabChanged() {
    if (_selectedCategory == null) {
      _shouldResetToDefault = true;
    }
    notifyListeners();
  }

  bool consumeResetToDefault() {
    final shouldReset = _shouldResetToDefault;
    _shouldResetToDefault = false;
    return shouldReset;
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
