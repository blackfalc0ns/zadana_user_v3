import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'shimmer_card.dart';

/// Grid من بطاقات الشيمر — reusable في أي screen فيها grid
class ShimmerGrid extends StatelessWidget {
  const ShimmerGrid({
    super.key,
    required this.animation,
    this.itemCount = 10,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.82,
  });

  final Animation<double> animation;
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        Spacing.screenH, Spacing.sm, Spacing.screenH, Spacing.xl,
      ),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: Spacing.base,
        crossAxisSpacing: Spacing.base,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => ShimmerCard(animation: animation),
    );
  }
}