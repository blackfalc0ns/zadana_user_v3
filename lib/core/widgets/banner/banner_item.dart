import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_content.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_data.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_image.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_overlay.dart';

class BannerItem extends StatelessWidget {
  const BannerItem({super.key, required this.banner, this.onTap});

  final BannerData banner;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        BannerImage(imageUrl: banner.imageUrl),
        const BannerOverlay(),
        BannerContent(banner: banner),
      ],
    );
  }
}
