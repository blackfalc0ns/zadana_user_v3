import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/pages/category_products_screen.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/best_selling_card.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/category_circle_row.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/explore_more_tile.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/featured_product_card.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_app_bar.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_data.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_search_bar.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/promo_banner.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/recommended_card.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/special_offer_card.dart';

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

          // ── Search ─────────────────────────────────────────────
          HomeSearchBar(),

          const SizedBox(height: Spacing.base),

          // ── Promo Banner ───────────────────────────────────────
          PromoBanner(
            tag:         locale.banner_tag,
            title:       locale.banner_title,
            subtitle:    locale.banner_subtitle,
            actionLabel: locale.banner_action,
            imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600',
          ),

          const SizedBox(height: Spacing.xl),
          // ── Shop by Category ───────────────────────────────────────
const SizedBox(height: Spacing.md),
// ── Categories ─────────────────────────────────
SectionHeader(
  title: 'تسوق حسب القسم',
  actionLabel: locale.see_all,
  onActionTap: () => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CategoryProductsScreen(
      category: kHomeCategories.first,
    ),
  ),
),
),
const SizedBox(height: Spacing.md),
CategoryCircleRow(
  categories: kHomeCategories,
  onCategoryTap: (cat) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CategoryProductsScreen(category: cat),
    ),
  ),
),

const SizedBox(height: Spacing.xl),

// ── Special Offers ...

          // ── Special Offers ─────────────────────────────────────
          SectionHeader(
            title:       locale.section_special_offers,
            actionLabel: locale.see_all,
          ),
          const SizedBox(height: Spacing.md),
          SizedBox(
            height: 210,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
              scrollDirection: Axis.horizontal,
              itemCount: HomeData.specialOffers.length,
              separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
              itemBuilder: (_, i) => SpecialOfferCard(
                product: HomeData.specialOffers[i],
              ),
            ),
          ),

          const SizedBox(height: Spacing.xl),

          // ── Best Selling ───────────────────────────────────────
          SectionHeader(
            title:       locale.section_best_selling,
            actionLabel: locale.see_all,
          ),
          const SizedBox(height: Spacing.md),
          SizedBox(
            height: 220,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
              scrollDirection: Axis.horizontal,
              itemCount: HomeData.bestSelling.length,
              separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
              itemBuilder: (_, i) => BestSellingCard(
                product: HomeData.bestSelling[i],
              ),
            ),
          ),

          const SizedBox(height: Spacing.xl),

          // ── Featured Products ──────────────────────────────────
          SectionHeader(
            title:       locale.section_featured,
            actionLabel: locale.see_all,
          ),
          const SizedBox(height: Spacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            child: Row(
              children: HomeData.featured
                  .map(
                    (p) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(
                          Spacing.sm,
                        ),
                        child: FeaturedProductCard(product: p),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: Spacing.xl),

          // ── Recommended For You ────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(locale.section_recommended, style: AppTextStyles.h4),
                TextButton(
                  onPressed: () {},
                  child: Text(locale.refresh),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.sm),
          SizedBox(
            height: 80,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
              scrollDirection: Axis.horizontal,
              itemCount: HomeData.recommended.length,
              separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
              itemBuilder: (_, i) => RecommendedCard(
                product: HomeData.recommended[i],
              ),
            ),
          ),

          const SizedBox(height: Spacing.xl),

          // ── Explore More ───────────────────────────────────────
          SectionHeader(
            title:       locale.section_explore,
            actionLabel: locale.see_all,
          ),
          const SizedBox(height: Spacing.sm),
          ...HomeData.exploreMore.map(
            (p) => ExploreMoreTile(
              product: p,
              addToCartLabel: locale.add_to_cart,
            ),
          ),

          const SizedBox(height: Spacing.xl),
        ],
      ),
    );
  }
}