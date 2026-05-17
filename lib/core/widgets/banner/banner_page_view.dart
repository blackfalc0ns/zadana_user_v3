import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_data.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_item.dart';

class BannerPageView extends StatelessWidget {
  const BannerPageView({
    super.key,
    required this.controller,
    required this.banners,
    required this.onPageChanged,
    this.onBannerTap,
  });

  final PageController controller;
  final List<BannerData> banners;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int>? onBannerTap;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: banners.length,
      itemBuilder: (context, index) {
        return BannerItem(
          banner: banners[index],
          onTap: onBannerTap != null ? () => onBannerTap!(index) : null,
        );
      },
    );
  }
}
