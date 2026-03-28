import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';

class BannerImage extends StatelessWidget {
  const BannerImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.image,
    this.fallbackIconSize = 50,
  });

  final String imageUrl;
  final BoxFit fit;
  final IconData fallbackIcon;
  final double fallbackIconSize;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      errorBuilder: (_, _, _) => _BannerImageFallback(
        icon: fallbackIcon,
        iconSize: fallbackIconSize,
      ),
    );
  }
}

class _BannerImageFallback extends StatelessWidget {
  const _BannerImageFallback({
    required this.icon,
    required this.iconSize,
  });

  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: Icon(
        icon,
        color: AppColors.white,
        size: iconSize,
      ),
    );
  }
}