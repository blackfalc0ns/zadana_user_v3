import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/skeleton_state_widget.dart';

class OrderDetailsLoadingView extends StatelessWidget {
  const OrderDetailsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonStateWidget(
      child: ListView(
        padding: const EdgeInsets.all(Spacing.base),
        children: const [
          DetailsSkeletonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsSkeletonLine(width: 180, height: 18),
                SizedBox(height: Spacing.sm),
                DetailsSkeletonLine(width: 140),
                SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Expanded(
                      child: DetailsSkeletonLine(
                        width: double.infinity,
                        height: 44,
                      ),
                    ),
                    SizedBox(width: Spacing.sm),
                    Expanded(
                      child: DetailsSkeletonLine(
                        width: double.infinity,
                        height: 44,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: Spacing.base),
          DetailsSkeletonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsSkeletonLine(width: 120, height: 18),
                SizedBox(height: Spacing.md),
                DetailsSkeletonLine(width: double.infinity),
                SizedBox(height: Spacing.sm),
                DetailsSkeletonLine(width: double.infinity),
                SizedBox(height: Spacing.sm),
                DetailsSkeletonLine(width: 200),
              ],
            ),
          ),
          SizedBox(height: Spacing.base),
          DetailsSkeletonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsSkeletonLine(width: 80, height: 18),
                SizedBox(height: Spacing.md),
                DetailsSkeletonLine(width: double.infinity, height: 60),
                SizedBox(height: Spacing.sm),
                DetailsSkeletonLine(width: double.infinity, height: 60),
                SizedBox(height: Spacing.sm),
                DetailsSkeletonLine(width: double.infinity, height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsSkeletonCard extends StatelessWidget {
  const DetailsSkeletonCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .16)),
      ),
      child: child,
    );
  }
}

class DetailsSkeletonLine extends StatelessWidget {
  const DetailsSkeletonLine({super.key, required this.width, this.height = 12});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: .85),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
