import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_container.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_data.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_page_view.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_dots_indicator.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  static const Duration _autoSlideDuration = Duration(seconds: 4);
  static const Duration _animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _initializeController();
    _startAutoSlide();
  }

  void _initializeController() {
    _pageController = PageController();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(_autoSlideDuration, (timer) {
      _goToNextPage();
    });
  }

  void _goToNextPage() {
    final banners = _getBanners();
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

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  List<BannerData> _getBanners() {
    final locale = context.localization;
    return [
      BannerData(
        tag: locale.banner_tag,
        title: locale.banner_title,
        subtitle: locale.banner_subtitle,
        actionLabel: locale.banner_action,
        imageUrl: 'https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=600',
      ),
      BannerData(
        tag: 'جديد',
        title: 'منتجات طازجة يومياً',
        subtitle: 'أفضل الخضروات والفواكه',
        actionLabel: 'اكتشف المزيد',
        imageUrl: 'https://images.unsplash.com/photo-1610348725531-843dff563e2c?w=600',
      ),
      BannerData(
        tag: 'توصيل مجاني',
        title: 'توصيل مجاني للطلبات فوق 100 ريال',
        subtitle: 'سرعة في التوصيل وجودة في الخدمة',
        actionLabel: 'اطلب الآن',
        imageUrl: 'https://images.unsplash.com/photo-1506976785307-8732e854ad03?w=600',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final banners = _getBanners();
    
    return BannerContainer(
      child: Stack(
        children: [
          BannerPageView(
            controller: _pageController,
            banners: banners,
            onPageChanged: _onPageChanged,
          ),
          BannerDotsIndicator(
            itemCount: banners.length,
            currentPage: _currentPage,
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }
}