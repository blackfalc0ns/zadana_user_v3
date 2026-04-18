import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/skeleton_state_widget.dart';

class OrdersLoadingWidget extends StatelessWidget {
  const OrdersLoadingWidget({super.key, this.itemCount = 4});
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SkeletonStateWidget(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
        itemBuilder: (context, index) {
          final color = Theme.of(context).colorScheme;
          return Container(
            padding: const EdgeInsets.all(Spacing.base),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(Spacing.xl),
              border: Border.all(
                color: color.outlineVariant.withValues(alpha: .45),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SkeletonIconBox(),
                    SizedBox(width: Spacing.md),
                    Expanded(child: SkeletonLine(width: 140)),
                    SizedBox(width: Spacing.md),
                    SkeletonPill(),
                  ],
                ),
                SizedBox(height: Spacing.base),
                SkeletonLine(width: 130),
                SizedBox(height: Spacing.sm),
                SkeletonLine(width: 180),
                SizedBox(height: Spacing.base),
                Row(
                  children: [
                    Expanded(child: SkeletonLine(width: 120)),
                    SizedBox(width: Spacing.md),
                    SkeletonPill(),
                  ],
                ),
                SizedBox(height: Spacing.base),
                Row(
                  children: [
                    Expanded(child: SkeletonButton()),
                    SizedBox(width: Spacing.sm),
                    Expanded(child: SkeletonButton()),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SkeletonLine extends StatelessWidget {
  const SkeletonLine({super.key, required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Container(
      width: width,
      height: 12,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .8),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class SkeletonPill extends StatelessWidget {
  const SkeletonPill({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Container(
      width: 78,
      height: 28,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .8),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class SkeletonButton extends StatelessWidget {
  const SkeletonButton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .8),
        borderRadius: BorderRadius.circular(Spacing.buttonSmallRadius),
      ),
    );
  }
}

class SkeletonIconBox extends StatelessWidget {
  const SkeletonIconBox({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .8),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
