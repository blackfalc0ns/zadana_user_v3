import 'package:flutter/material.dart';
import 'dart:async';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_app_bar.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/promo_banner.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/best_selling_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/categories_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/explore_more_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/featured_products_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/recommended_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/special_offers_section.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/brands_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInitialLoading = true;
  Timer? _loadingTimer;

  void _startFakeLoading() {
    _loadingTimer?.cancel();
    setState(() => _isInitialLoading = true);
    _loadingTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isInitialLoading = false);
    });
  }

  @override
  void initState() {
    super.initState();
    _startFakeLoading();
  }

  @override
  void reassemble() {
    super.reassemble();
    _startFakeLoading();
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Scaffold(
      appBar: HomeAppBar(
        deliverToLabel: locale.deliver_to,
        location: locale.location,
        onMenuTap: widget.onMenuTap,
      ),
      body: CustomScrollView(
        key: const PageStorageKey<String>('home_scroll_view'),
        slivers: [
          SliverToBoxAdapter(child: const SizedBox(height: Spacing.sm)),

          if (_isInitialLoading) ...[
            // Banner Skeleton
            const SliverToBoxAdapter(
              child: ShimmerEffect(child: BannerSkeleton()),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),

            // Categories Skeleton
            const SliverToBoxAdapter(
              child: ShimmerEffect(child: CategoriesSectionSkeleton()),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),

            // Product Sections Skeletons
            const SliverToBoxAdapter(
              child: ShimmerEffect(child: SectionSkeleton(cardCount: 3)),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),
            const SliverToBoxAdapter(
              child: ShimmerEffect(child: SectionSkeleton(cardCount: 3)),
            ),
          ] else ...[
            // Actual Content
            // Promo Banner
            SliverToBoxAdapter(child: const PromoBanner()),

            SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),

            // 1. Categories Section
            SliverToBoxAdapter(child: const CategoriesSection()),

          //  SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),

            // 2. Special Offers Section
            SliverToBoxAdapter(child: const SpecialOffersSection()),

            SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),

            // 3. Recommended Section
            SliverToBoxAdapter(child: const RecommendedSection()),

            SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),

            // 4. Best Selling Section
            SliverToBoxAdapter(child: const BestSellingSection()),

            SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),
            // 5. Brands Section
            SliverToBoxAdapter(child: const BrandsSection()),

            SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),

            // 6. Featured Products Section
            SliverToBoxAdapter(child: const FeaturedProductsSection()),

            SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),

            // 7. Explore More Section
            SliverToBoxAdapter(child: const ExploreMoreSection()),
          ],

          SliverToBoxAdapter(child: const SizedBox(height: 100)),
        ],
      ),
    );
  }
}
