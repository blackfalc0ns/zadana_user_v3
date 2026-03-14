import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';

/// Service لإدارة التنقل بين الأقسام من الهوم سكرين لتاب التسوق
class CategoryNavigationService extends ChangeNotifier {
  static final CategoryNavigationService _instance = CategoryNavigationService._internal();
  factory CategoryNavigationService() => _instance;
  CategoryNavigationService._internal();

  CategoryEntity? _selectedCategory;
  
  /// القسم المختار من الهوم سكرين
  CategoryEntity? get selectedCategory => _selectedCategory;
  
  /// تحديد القسم المختار
  void setSelectedCategory(CategoryEntity category) {
    _selectedCategory = category;
    notifyListeners();
  }
  
  /// مسح القسم المختار
  void clearSelectedCategory() {
    _selectedCategory = null;
    notifyListeners();
  }
  
  /// إشعار بتغيير التاب
  void notifyTabChanged() {
    notifyListeners();
  }
  
  /// تحويل من CategoryEntity إلى اسم القسم المستخدم في CategoryScreen
  String? getCategoryNameForScreen() {
    if (_selectedCategory == null) return null;
    
    // تحويل من id إلى اسم القسم
    switch (_selectedCategory!.id) {
      case 'cat1': return 'خضروات';
      case 'cat5': return 'ألبان';
      case 'cat6': return 'مخبوزات';
      case 'cat3': return 'لحوم';
      case 'cat7': return 'مشروبات';
      case 'cat8': return 'منزلية';
      case 'cat9': return 'عناية';
      case 'cat10': return 'سناكس';
      default: return null;
    }
  }
}