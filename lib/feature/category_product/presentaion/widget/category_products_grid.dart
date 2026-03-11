import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/widgets/compact_product_card.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_model.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_converter.dart';

class CategoryProductsGrid extends StatelessWidget {
  const CategoryProductsGrid({
    super.key,
    required this.products,
    required this.gridController,
    required this.selectedSubId,
    required this.onProductAdd,
    required this.onProductFavorite,
  });

  final List<CategoryProductModel> products;
  final AnimationController gridController;
  final String selectedSubId;
  final ValueChanged<CategoryProductModel> onProductAdd;
  final ValueChanged<CategoryProductModel> onProductFavorite;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      key: ValueKey('products_$selectedSubId'),
      padding: const EdgeInsets.fromLTRB(
        Spacing.screenH,
        Spacing.sm,
        Spacing.screenH,
        Spacing.xl,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 منتجات في الصف
        crossAxisSpacing: Spacing.md,
        mainAxisSpacing: Spacing.md,
        childAspectRatio: 0.85, // نسبة محسنة
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildAnimatedProductCard(context, products[index], index);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📦', style: TextStyle(fontSize: 52)),
          const SizedBox(height: Spacing.base),
          Text(
            'لا توجد منتجات في هذا القسم',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedProductCard(BuildContext context, CategoryProductModel product, int index) {
    final start = ((index * 60) / 600).clamp(0.0, 1.0);
    final end = (start + 0.5).clamp(0.0, 1.0);

    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: gridController,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );

    return FadeTransition(
      opacity: fade,
      child: CompactProductCard(
        product: CategoryProductConverter.toProductModel(product),
        showFavorite: true,
        onAddTap: () => onProductAdd(product),
        onFavoriteTap: () => onProductFavorite(product),
        onCardTap: () => _navigateToProductDetails(context, product),
      ),
    );
  }

  void _navigateToProductDetails(BuildContext context, CategoryProductModel product) {
    Navigator.pushNamed(
      context,
      AppRoutes.productDetails,
      arguments: product,
    );
  }
}