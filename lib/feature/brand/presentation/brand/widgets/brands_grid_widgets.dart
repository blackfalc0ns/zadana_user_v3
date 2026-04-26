import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/brand/presentation/brand_details/pages/brand_details_page_view.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/brand_card.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart'
    show ShimmerEffect;

class BrandGridTile extends StatelessWidget {
  const BrandGridTile({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final fallbackSymbol = brand.name.trim().isEmpty
        ? '*'
        : brand.name.trim().substring(0, 1);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BrandCard(
        name: brand.name,
        imageUrl: brand.logo,
        emoji: brand.emoji ?? fallbackSymbol,
        isCompact: true,
        compactFontSize: FontSize.size11,
        onTap: () {
          Navigator.of(
            context,
          ).push(
            MaterialPageRoute(builder: (_) => BrandDetailsPage(brand: brand)),
          );
        },
      ),
    );
  }
}

class BrandsLoadingView extends StatelessWidget {
  const BrandsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerEffect(
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(Spacing.md, 0, Spacing.md, 72),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                _buildSkeletonItem,
                childCount: 12,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.82,
                crossAxisSpacing: 8,
                mainAxisSpacing: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSkeletonItem(BuildContext context, int index) =>
      const BrandCardSkeleton();
}

class BrandsErrorView extends StatelessWidget {
  const BrandsErrorView({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(Spacing.md),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.72,
          child: Center(
            child: ApiErrorWidget(
              exception: failure.exception,
              onRetry: onRetry,
            ),
          ),
        ),
      ],
    );
  }
}

class BrandsEmptyView extends StatelessWidget {
  const BrandsEmptyView({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.72,
          child: Center(
            child: EmptyStateWidget(
              title: title,
              description: description,
              icon: Icons.storefront_outlined,
            ),
          ),
        ),
      ],
    );
  }
}

class BrandCardSkeleton extends StatelessWidget {
  const BrandCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                color.onSurface.withValues(alpha: 0.06),
                color.surfaceContainerHighest,
              ),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 44,
            height: 8,
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                color.onSurface.withValues(alpha: 0.06),
                color.surfaceContainerHighest,
              ),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 28,
            height: 8,
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                color.onSurface.withValues(alpha: 0.04),
                color.surfaceContainerHigh,
              ),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }
}
