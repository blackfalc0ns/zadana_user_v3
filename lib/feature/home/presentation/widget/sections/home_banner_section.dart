import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_container.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/promo_banner.dart';

class HomeBannerSection extends StatelessWidget {
  const HomeBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.bannerSection != current.bannerSection,
      builder: (context, state) {
        if (state.bannerSection.isLoading) {
          return const _HomeBannerLoadingSection();
        }

        final bannerSection = state.bannerSection.data;
        if (bannerSection?.isActive == false) {
          return const SizedBox.shrink();
        }

        if (state.bannerSection.failure != null &&
            (bannerSection == null || bannerSection.items.isEmpty)) {
          return const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _OfflineBannerSection(),
              SizedBox(height: Spacing.lg),
            ],
          );
        }

        if (bannerSection == null || bannerSection.items.isEmpty) {
          return const SizedBox.shrink();
        }

        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PromoBanner(),
            SizedBox(height: Spacing.lg),
          ],
        );
      },
    );
  }
}

class _HomeBannerLoadingSection extends StatelessWidget {
  const _HomeBannerLoadingSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShimmerEffect(child: BannerSkeleton()),
        SizedBox(height: Spacing.lg),
      ],
    );
  }
}

class _OfflineBannerSection extends StatelessWidget {
  const _OfflineBannerSection();

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return BannerContainer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B7B8E), Color(0xFF1393A8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 38),
            const SizedBox(height: 8),
            Text(
              locale.error_no_internet,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
