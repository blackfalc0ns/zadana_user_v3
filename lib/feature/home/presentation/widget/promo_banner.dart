import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_container.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_data.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_dots_indicator.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_page_view.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_banner_item_entity.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  static const Duration _autoSlideDuration = Duration(seconds: 4);
  static const Duration _animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _startAutoSlide(List<BannerData> banners) {
    _timer?.cancel();
    _timer = Timer.periodic(_autoSlideDuration, (_) {
      _goToNextPage(banners);
    });
  }

  void _goToNextPage(List<BannerData> banners) {
    if (banners.isEmpty) return;

    if (_currentPage < banners.length - 1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }

    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _currentPage,
        duration: _animationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  List<BannerData> _mapBannerItems(List<HomeBannerItemEntity> items) {
    return items
        .map(
          (item) => BannerData(
            tag: item.tag,
            title: item.title,
            subtitle: item.subtitle,
            actionLabel: item.actionLabel,
            imageUrl: item.imageUrl,
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.bannerSection != current.bannerSection,
      builder: (context, state) {
        final bannerSection = state.bannerSection.data;

        if (bannerSection == null ||
            !bannerSection.isActive ||
            bannerSection.items.isEmpty) {
          return const SizedBox.shrink();
        }

        final banners = _mapBannerItems(bannerSection.items);
        if (banners.isEmpty) {
          _timer?.cancel();
          return const SizedBox.shrink();
        }

        if (_currentPage >= banners.length) {
          _currentPage = 0;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (_timer == null || !_timer!.isActive) {
            _startAutoSlide(banners);
          }
        });

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BannerContainer(
              child: BannerPageView(
                controller: _pageController,
                banners: banners,
                onPageChanged: _onPageChanged,
                onBannerTap: (_) => mainShellKey.currentState?.jumpToTab(1),
              ),
            ),
            const SizedBox(height: 8),
            BannerDotsIndicator(
              itemCount: banners.length,
              currentPage: _currentPage,
            ),
          ],
        );
      },
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }
}
