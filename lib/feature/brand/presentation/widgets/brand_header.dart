import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({
    super.key,
    required this.brand,
  });

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 230,
      floating: false,
      pinned: false,
      snap: false,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: _buildBackButton(context),
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildLogo(),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInfo()),
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
    return Image.network(
      brand.coverImage ??
          'https://images.unsplash.com/photo-1563636619-e9143da7973b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFFF3EEE8),
        );
      },
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
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.white,
          size: 18,
        ),
        onPressed: () => Navigator.pop(context),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildLogo() {
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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: brand.logo.isNotEmpty
              ? Image.network(
                  brand.logo,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(
                      brand.emoji ?? '🏪',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    brand.emoji ?? '🏪',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
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
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.22),
            ),
          ),
          child: Text(
            '${brand.productCount} منتج',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
