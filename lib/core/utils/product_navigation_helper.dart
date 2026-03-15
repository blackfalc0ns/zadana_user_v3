import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_model.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/pages/product_details_screen.dart';

class ProductNavigationHelper {
  /// تحويل ProductModel إلى CategoryProductModel للـ navigation
  static CategoryProductModel convertToNavigationModel(ProductModel product) {
    return CategoryProductModel(
      id: product.id,
      name: product.name,
      subCategoryId: 'general', // قيمة افتراضية
      price: product.price,
      oldPrice: product.oldPrice,
      emoji: product.emoji ?? '📦', // emoji افتراضي لو مش موجود
      isFavorite: product.isFavorite,
    );
  }

  /// الانتقال لصفحة تفاصيل المنتج
  static void navigateToProductDetails(BuildContext context, ProductModel product) {
    final navigationModel = convertToNavigationModel(product);
    
    // استخدام الـ routing المحسن بدلاً من pushScreenWithoutNavBar
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailsScreen(product: navigationModel),
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // انيميشن محسن يعمل من أي مكان في الشاشة
          return FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
              ),
            ),
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.92,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutBack,
                ),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}