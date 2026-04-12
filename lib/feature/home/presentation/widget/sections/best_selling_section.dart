import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/home_product_cart_helper.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

class BestSellingSection extends StatelessWidget {
  const BestSellingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.bestSellingSection != current.bestSellingSection,
      builder: (context, state) {
        if (state.bestSellingSection.isLoading) {
          return Column(
            children: [
              SectionHeader(
                title: locale.section_best_selling,
                actionLabel: locale.see_all,
              ),
              const SizedBox(height: Spacing.md),
              const SizedBox(
                height: 130,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spacing.screenH),
                  child: ShimmerEffect(child: _BestSellingItemsSkeleton()),
                ),
              ),
            ],
          );
        }

        final section = state.bestSellingSection.data;
        if (section?.isActive == false) {
          return const SizedBox.shrink();
        }

        if (state.bestSellingSection.failure != null &&
            state.bestSellingSection.data == null) {
          return Column(
            children: [
              SectionHeader(
                title: locale.section_best_selling,
                actionLabel: locale.see_all,
              ),
              const SizedBox(height: Spacing.md),
              const _OfflineBestSellingSection(),
            ],
          );
        }

        final items = section?.items ?? const <ProductModel>[];
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            SectionHeader(
              title: locale.section_best_selling,
              actionLabel: locale.see_all,
            ),
            const SizedBox(height: Spacing.md),
            SizedBox(
              height: 140,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
                itemBuilder: (_, i) {
                  final product = items[i];
                  final heroTag = productHeroTag(
                    product.id,
                    source: 'home-best-selling',
                  );
                  return SizedBox(
                    width: 120,
                    child: CustomProductCard(
                      discountPercentage: product.discountPercentage,
                      isDiscounted: product.isDiscounted,
                      product: product,
                      heroTag: heroTag,
                      showFavorite: true,
                      onAddTap: () => HomeProductCartHelper.addProductToCart(
                        context,
                        product,
                      ),
                      onCardTap: () => ProductNavigationHelper
                          .navigateToProductDetails(
                            context,
                            product,
                            heroTag: heroTag,
                          ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BestSellingItemsSkeleton extends StatelessWidget {
  const _BestSellingItemsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
      itemBuilder: (_, _) => const ProductCardSkeleton(),
    );
  }
}

class _OfflineBestSellingSection extends StatelessWidget {
  const _OfflineBestSellingSection();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.lg,
        ),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.outline.withValues(alpha: 0.15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 34,
              color: color.primary,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              locale.best_selling_unavailable,
              style: getSemiBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
