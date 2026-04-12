import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/brand/presentation/pages/brand_page.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/brand_card.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection({super.key});

  void _navigateToBrandPage(BuildContext context, BrandModel brand) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BrandPage(brand: brand)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.brandsSection != current.brandsSection,
      builder: (context, state) {
        if (state.brandsSection.isLoading) {
          return const _BrandsLoadingSection();
        }

        final section = state.brandsSection.data;
        if (section?.isActive == false) {
          return const SizedBox.shrink();
        }

        if (state.brandsSection.failure != null &&
            state.brandsSection.data == null) {
          return const SizedBox.shrink();
        }

        final items = section?.items ?? const <BrandModel>[];
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return _BrandsSectionContainer(
          child: Column(
            children: [
              SectionHeader(
                actionColor: Colors.white,
                title: locale.section_brands,
                actionLabel: locale.see_all,
                isActionBold: true,
                titleColor: AppColors.white,
                horizontalPadding: 16,
              ),
              const SizedBox(height: Spacing.md),
              SizedBox(
                height: 180,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: Spacing.sm,
                    mainAxisSpacing: Spacing.sm,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final brand = items[index];
                    return BrandCard(
                      name: brand.name,
                      emoji: brand.emoji ?? brand.name.substring(0, 1),
                      onTap: () => _navigateToBrandPage(context, brand),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BrandsSectionContainer extends StatelessWidget {
  const _BrandsSectionContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      decoration: const BoxDecoration(color: AppColors.primary),
      margin: EdgeInsets.zero,
      child: child,
    );
  }
}

class _BrandsLoadingSection extends StatelessWidget {
  const _BrandsLoadingSection();

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return _BrandsSectionContainer(
      child: Column(
        children: [
          SectionHeader(
            actionColor: Colors.white,
            title: locale.section_brands,
            actionLabel: locale.see_all,
            isActionBold: true,
            titleColor: AppColors.white,
            horizontalPadding: 16,
          ),
          const SizedBox(height: Spacing.md),
          const SizedBox(
            height: 180,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Spacing.sm),
              child: ShimmerEffect(child: _BrandsGridSkeleton()),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandsGridSkeleton extends StatelessWidget {
  const _BrandsGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Spacing.sm,
        mainAxisSpacing: Spacing.sm,
        childAspectRatio: 0.9,
      ),
      itemCount: 6,
      itemBuilder: (_, _) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
        ),
        padding: const EdgeInsets.all(Spacing.xs),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Bone(width: 45, height: 45, radius: 999),
            SizedBox(height: 8),
            Bone(width: 50, height: 10, radius: 999),
          ],
        ),
      ),
    );
  }
}
