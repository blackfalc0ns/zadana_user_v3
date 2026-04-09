import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';

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
    final imageShell = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: ColoredBox(
          color: whiteBackground ? AppColors.white : AppColors.background,
          child: emoji != null && emoji!.isNotEmpty
              ? _buildEmoji()
              : _buildImage(),
        ),
      ),
    );

    if (heroTag == null || heroTag!.isEmpty) {
      return imageShell;
    }

    return Hero(
      tag: heroTag!,
      transitionOnUserGestures: true,
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
    if (url.isEmpty) {
      return _errorWidget();
    }

    final resolvedFit = whiteBackground ? BoxFit.contain : fit;

    return Padding(
      padding: EdgeInsets.all(whiteBackground ? 8 : 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final image = url.startsWith('assets/')
              ? Image.asset(
                  url,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  fit: resolvedFit,
                  alignment: Alignment.center,
                  errorBuilder: (_, _, _) => _errorWidget(),
                )
              : Image.network(
                  url,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  fit: resolvedFit,
                  alignment: Alignment.center,
                  errorBuilder: (_, _, _) => _errorWidget(),
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return const ColoredBox(color: AppColors.shimmerBase);
                  },
                );

          return Center(child: image);
        },
      ),
    );
  }

  Widget _errorWidget() {
    return const ColoredBox(
      color: AppColors.divider,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textHint,
        ),
      ),
    );
  }
}
