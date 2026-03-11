import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_app_bar.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_search_bar.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/promo_banner.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/best_selling_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/categories_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/explore_more_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/featured_products_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/recommended_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/special_offers_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(
        deliverToLabel: locale.deliver_to,
        location: locale.location,
      ),
      body: ListView(
        children: [
          const SizedBox(height: Spacing.sm),

          // Search Bar
          HomeSearchBar(),
          const SizedBox(height: Spacing.base),

          // Promo Banner
          PromoBanner(
            tag: locale.banner_tag,
            title: locale.banner_title,
            subtitle: locale.banner_subtitle,
            actionLabel: locale.banner_action,
            imageUrl:
                'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600',
          ),

          const SizedBox(height: Spacing.xl),

          // 1. Categories Section
          const CategoriesSection(),

          const SizedBox(height: Spacing.xl),

          // 2. Special Offers Section
          const SpecialOffersSection(),

          const SizedBox(height: Spacing.xl),

          // 3. Best Selling Section
          const BestSellingSection(),

          const SizedBox(height: Spacing.xl),

          // 4. Featured Products Section
          const FeaturedProductsSection(),

          const SizedBox(height: Spacing.xl),

          // 5. Recommended For You Section
          const RecommendedSection(),

          const SizedBox(height: Spacing.xl),

          // 6. Explore More Section
          const ExploreMoreSection(),

          const SizedBox(height: Spacing.xl),
        ],
      ),
    );
  }
}
