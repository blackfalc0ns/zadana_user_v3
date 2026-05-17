import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';

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
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      placeholder: (_, _) => const _BannerImageLoading(),
      errorWidget: (_, _, _) =>
          _BannerImageFallback(iconSize: fallbackIconSize),
    );
  }
}

class _BannerImageLoading extends StatelessWidget {
  const _BannerImageLoading();

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Container(
        color: AppColors.primary.withValues(alpha: 0.15),
      ),
    );
  }
}

class _BannerImageFallback extends StatelessWidget {
  const _BannerImageFallback({required this.iconSize});

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Color(0xFF1393A8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Assets.logoDark,
              width: 72,
              height: 44,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
