import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/base_product_card.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_data.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

class FeaturedProductsSection extends StatelessWidget {
  const FeaturedProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Column(
      children: [
        SectionHeader(
          title: locale.section_featured,
          actionLabel: locale.see_all,
        ),
        const SizedBox(height: Spacing.md),
        
        // Grid View للمنتجات المميزة (2 صف × scroll أفقي)
        SizedBox(
          height: 340, // ارتفاع أصغر للكاردز الصغيرة
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            scrollDirection: Axis.horizontal, // scroll أفقي
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 صف
              crossAxisSpacing: Spacing.sm,
              mainAxisSpacing: Spacing.sm,
             childAspectRatio: 1.1, // نسبة أفضل للكاردز الصغيرة
            ),
            itemCount: HomeData.featured.length,
            itemBuilder: (context, index) {
              final product = HomeData.featured[index];
              return BaseProductCard(
                product: product,
                width: 150,
                imageHeight: 70,
                showFavorite: true,
                onAddTap: () {
                  // TODO: إضافة المنتج للعربة
                  print('Added ${product.name} to cart');
                },
                onCardTap: () {
                  // TODO: الانتقال لصفحة المنتج
                  print('Navigate to ${product.name} details');
                },
                onFavoriteTap: () {
                  // TODO: إضافة/إزالة من المفضلة
                  print('Toggle favorite for ${product.name}');
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
