import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

class OrdersLoadingWidget extends StatelessWidget {
  final int itemCount;

  const OrdersLoadingWidget({
    super.key,
    this.itemCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return ListView.separated(
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(Spacing.base),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(Spacing.xl),
            border: Border.all(color: color.outlineVariant.withValues(alpha: .45)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  _SkeletonIconBox(),
                  SizedBox(width: Spacing.md),
                  Expanded(child: _SkeletonLine(width: 140)),
                  SizedBox(width: Spacing.md),
                  _SkeletonPill(),
                ],
              ),
              SizedBox(height: Spacing.base),
              _SkeletonLine(width: 130),
              SizedBox(height: Spacing.sm),
              _SkeletonLine(width: 180),
              SizedBox(height: Spacing.base),
              Row(
                children: [
                  Expanded(child: _SkeletonLine(width: 120)),
                  SizedBox(width: Spacing.md),
                  _SkeletonPill(),
                ],
              ),
              SizedBox(height: Spacing.base),
              Row(
                children: [
                  Expanded(child: _SkeletonButton()),
                  SizedBox(width: Spacing.sm),
                  Expanded(child: _SkeletonButton()),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double width;

  const _SkeletonLine({required this.width});

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

class _SkeletonPill extends StatelessWidget {
  const _SkeletonPill();

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

class _SkeletonButton extends StatelessWidget {
  const _SkeletonButton();

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

class _SkeletonIconBox extends StatelessWidget {
  const _SkeletonIconBox();

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
