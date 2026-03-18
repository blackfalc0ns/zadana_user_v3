import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/app_drawer.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_app_bar.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_search_bar.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/promo_banner.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/best_selling_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/categories_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/explore_more_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/featured_products_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/recommended_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/special_offers_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/stores_section.dart';

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
      drawer: const AppDrawer(),
      appBar: HomeAppBar(
        deliverToLabel: locale.deliver_to,
        location: locale.location,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: const SizedBox(height: Spacing.sm)),

          // Search Bar
          SliverToBoxAdapter(child: HomeSearchBar()),
          SliverToBoxAdapter(child: const SizedBox(height: Spacing.base)),

          // Promo Banner
          SliverToBoxAdapter(child: const PromoBanner()),

          SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),

          // 1. Categories Section
          SliverToBoxAdapter(child: const CategoriesSection()),

          SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),

          // 3. Recommended For You Section

          // 3. Special Offers Section
          SliverToBoxAdapter(child: const SpecialOffersSection()),

          SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),
          SliverToBoxAdapter(child: const RecommendedSection()),

          SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),

          // 4. Best Selling Section
          SliverToBoxAdapter(child: const BestSellingSection()),
          // 2. Stores Section
          SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),

          SliverToBoxAdapter(child: const StoresSection()),

          SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),

          // 5. Featured Products Section
          SliverToBoxAdapter(child: const FeaturedProductsSection()),

          SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),

          // 6. Explore More Section
          SliverToBoxAdapter(child: const ExploreMoreSection()),

          SliverToBoxAdapter(child: const SizedBox(height: 100)),
        ],
      ),
    );
  }
}
