import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_data.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_image.dart';

class BannerItem extends StatelessWidget {
  const BannerItem({super.key, required this.banner, this.onTap});

  final BannerData banner;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          BannerImage(imageUrl: banner.imageUrl),
        ],
      ),
    );
  }
}
