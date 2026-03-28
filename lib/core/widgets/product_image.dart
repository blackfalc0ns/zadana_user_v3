import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.borderRadius = 12.0,
    this.fit = BoxFit.cover,
    this.whiteBackground = false,
    this.emoji,
    this.heroTag,
  });

  final String url;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;
  final bool whiteBackground;
  final String? emoji;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return _buildImageShell();
  }

  Widget _buildImageShell() {
    final childContent = emoji != null && emoji!.isNotEmpty ? _buildEmoji() : _buildImage();
    
    final heroChild = (heroTag == null || heroTag!.isEmpty)
        ? childContent
        : Hero(
            tag: heroTag!,
            transitionOnUserGestures: true,
            child: Material(color: Colors.transparent, child: childContent),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: whiteBackground ? AppColors.white : AppColors.background,
        child: heroChild,
      ),
    );
  }

  Widget _buildEmoji() {
    return Center(
      child: Text(
        emoji!,
        style: TextStyle(fontSize: (height * 0.55).clamp(28, 200)),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildImage() {
    if (url.isEmpty) {
      return Container(
        color: AppColors.divider,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textHint,
        ),
      );
    }

    final resolvedFit = whiteBackground ? BoxFit.contain : fit;
    final child = url.startsWith('assets/')
        ? Image.asset(
            url,
            width: width,
            height: height,
            fit: resolvedFit,
            errorBuilder: (_, _, _) => _errorWidget(),
          )
        : Image.network(
            url,
            width: width,
            height: height,
            fit: resolvedFit,
            errorBuilder: (_, _, _) => _errorWidget(),
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(color: AppColors.shimmerBase);
            },
          );

    return whiteBackground
        ? Padding(padding: const EdgeInsets.all(8), child: child)
        : child;
  }

  Widget _errorWidget() {
    return Container(
      color: AppColors.divider,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.textHint,
      ),
    );
  }
}
