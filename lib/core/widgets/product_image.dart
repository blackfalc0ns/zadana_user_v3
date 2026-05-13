import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
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
      child: SizedBox(
        width: width,
        height: height,
        child: ColoredBox(
          color:
              backgroundColor ??
              (whiteBackground ? AppColors.white : Colors.transparent),
          child: (url?.isNotEmpty ?? false)
              ? _buildImage()
              : (emoji != null && emoji!.isNotEmpty
                    ? _buildEmoji()
                    : _errorWidget()),
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

  Widget _buildEmoji() {
    return SizedBox.expand(
      child: Center(
        child: Text(
          emoji!,
          style: TextStyle(
            fontSize: (height * 0.42)
                .clamp(FontSize.size24, FontSize.size30)
                .toDouble(),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = url;
    if (imageUrl == null || imageUrl.isEmpty) {
      return _errorWidget();
    }

    // final resolvedFit = fit;
    // final imagePadding = whiteBackground && resolvedFit == BoxFit.contain
    //     ? 8.0
        //: 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        
             Image.network(
                imageUrl,
                // width: constraints.maxWidth,
                // height: constraints.maxHeight,
               
                filterQuality: FilterQuality.high,
                errorBuilder: (_, _, _) => _errorWidget(),
              );

        final networkImage = CachedNetworkImage(
          imageUrl: imageUrl,
          
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              strokeWidth: .5,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          errorWidget: (context, url, error) => _errorWidget(),
        );

        return networkImage;
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
