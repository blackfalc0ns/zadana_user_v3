import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({
    super.key,
    required this.brand,
    required this.productCount,
  });

  final BrandModel brand;
  final int productCount;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 230,
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildCover(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withValues(alpha: 0.08),
                    AppColors.black.withValues(alpha: 0.18),
                    AppColors.black.withValues(alpha: 0.42),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: _buildBackButton(context),
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildLogo(),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInfo(context)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCover() {
    final imageUrl = _resolveCoverImageUrl();
    if (imageUrl == null) {
      return Image.asset(Assets.notFound, fit: BoxFit.cover);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fill,
      placeholder: (context, url) => ShimmerEffect(
        child: Container(
          color: AppColors.white.withValues(alpha: 0.22),
        ),
      ),
      errorWidget: (context, url, error) =>
          Image.asset(Assets.notFound, fit: BoxFit.cover),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
      ),
      child: IconTheme(
        data: const IconThemeData(color: AppColors.white, size: 18),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    Widget fallbackLogo() {
      return Container(
        color: const Color(0xFFF2F4F7),
        padding: const EdgeInsets.all(6),
        child: Image.asset(Assets.notFound, fit: BoxFit.cover),
      );
    }

    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: brand.logo.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: brand.logo,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => fallbackLogo(),
              )
            : fallbackLogo(),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          brand.name,
          style: AppTextStyles.h2.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w800,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.white.withValues(alpha: 0.22)),
          ),
          child: Text(
            context.localization.brand_product_count(productCount),
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  String? _resolveCoverImageUrl() {
    final coverImage = brand.coverImage?.trim();
    if (coverImage != null && coverImage.isNotEmpty) {
      return coverImage;
    }

    final logo = brand.logo.trim();
    if (logo.isNotEmpty) {
      return logo;
    }

    return null;
  }
}
