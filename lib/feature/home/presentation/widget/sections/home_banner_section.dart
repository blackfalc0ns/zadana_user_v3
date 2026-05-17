import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

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
          return const SizedBox.shrink();
        }

        if (bannerSection == null || bannerSection.items.isEmpty) {
          return const SizedBox.shrink();
        }

        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PromoBanner(),
          
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
        SizedBox(height: Spacing.sm,)
      ],
    );
  }
}
