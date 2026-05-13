import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.borderRadius = 12.0,
    this.fit = BoxFit.cover,
    this.whiteBackground = false,
    this.backgroundColor,
    this.emoji,
    this.heroTag,
  });

  final String? url;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;
  final bool whiteBackground;
  final Color? backgroundColor;
  final String? emoji;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final imageShell = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ColoredBox(
        color: backgroundColor ??
            (whiteBackground ? Colors.white : Colors.transparent),
        child: SizedBox(
          width: width,
          height: height,
          child: _buildImage(),
        ),
      ),
    );

    if (heroTag == null || heroTag!.isEmpty) {
      return imageShell;
    }

    return Hero(
      tag: heroTag!,
      transitionOnUserGestures: true,
      createRectTween: (begin, end) {
        return MaterialRectCenterArcTween(begin: begin, end: end);
      },
      placeholderBuilder: (context, heroSize, child) {
        return Opacity(opacity: 0, child: child);
      },
      flightShuttleBuilder:
          (
            flightContext,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ) {
            final destinationHero = toHeroContext.widget as Hero;
            return destinationHero.child;
          },
      child: Material(color: Colors.transparent, child: imageShell),
    );
  }

 

  Widget _buildImage() {
    // final imageUrl = url;
    // if (imageUrl == null || imageUrl.isEmpty) {
    //   return _errorWidget();
    // }

    return LayoutBuilder(
      builder: (context, constraints) {
        return CachedNetworkImage(
          imageUrl: url ?? '',
        //   width: constraints.maxWidth.isFinite ? constraints.maxWidth : width,
        //   height: constraints.maxHeight.isFinite ? constraints.maxHeight : height,
        // //  fit: fit,
        //  filterQuality: FilterQuality.high,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              strokeWidth: .5,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          errorWidget: (context, url, error) => _errorWidget(),
        );
      },
    );
  }

  Widget _errorWidget() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Image.asset(
        Assets.notFound,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) {
          return const ColoredBox(
            color: AppColors.divider,
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.textHint,
              ),
            ),
          );
        },
      ),
    );
  }
}
