import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/skeleton_state_widget.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';

class TrackOrderLoadingView extends StatelessWidget {
  const TrackOrderLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonStateWidget(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(Spacing.base),
        children: const [
          _TrackOrderSkeletonCard(
            padding: EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TrackOrderBone(width: 58, height: 58, radius: 18),
                    SizedBox(width: Spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TrackOrderBone(width: 110, height: 16, radius: 999),
                          SizedBox(height: 10),
                          _TrackOrderBone(
                            width: double.infinity,
                            height: 28,
                            radius: 999,
                          ),
                          SizedBox(height: 8),
                          _TrackOrderBone(width: 160, height: 28, radius: 999),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Spacing.md),
                Row(
                  children: [
                    _TrackOrderBone(width: 110, height: 38, radius: 16),
                    Spacer(),
                    _TrackOrderBone(width: 150, height: 44, radius: 16),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: Spacing.base),
          _TrackOrderSkeletonCard(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.md,
            ),
            child: _TrackOrderBone(
              width: double.infinity,
              height: 160,
              radius: 22,
            ),
          ),
          SizedBox(height: Spacing.base),
          _TrackOrderSkeletonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _TrackOrderBone(width: 22, height: 22, radius: 999),
                    SizedBox(width: 8),
                    _TrackOrderBone(width: 120, height: 18, radius: 999),
                  ],
                ),
                SizedBox(height: Spacing.md),
                _TrackOrderTimelineSkeletonItem(showTime: true),
                SizedBox(height: Spacing.md),
                _TrackOrderTimelineSkeletonItem(showTime: true),
                SizedBox(height: Spacing.md),
                _TrackOrderTimelineSkeletonItem(),
                SizedBox(height: Spacing.md),
                _TrackOrderTimelineSkeletonItem(last: true),
              ],
            ),
          ),
          SizedBox(height: Spacing.base),
          _TrackOrderBone(width: double.infinity, height: 54, radius: 18),
        ],
      ),
    );
  }
}

class _TrackOrderTimelineSkeletonItem extends StatelessWidget {
  const _TrackOrderTimelineSkeletonItem({
    this.showTime = false,
    this.last = false,
  });

  final bool showTime;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const _TrackOrderBone(width: 28, height: 28, radius: 999),
              if (!last)
                Expanded(
                  child: Container(
                    width: 3,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: .85),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _TrackOrderBone(
                  width: double.infinity,
                  height: 22,
                  radius: 999,
                ),
                if (showTime) ...[
                  const SizedBox(height: 10),
                  const _TrackOrderBone(width: 86, height: 32, radius: 999),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackOrderSkeletonCard extends StatelessWidget {
  const _TrackOrderSkeletonCard({
    required this.child,
    this.padding = const EdgeInsets.all(Spacing.base),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(borderRadius: 28, padding: padding, child: child);
  }
}

class _TrackOrderBone extends StatelessWidget {
  const _TrackOrderBone({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: .85),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
