import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/widgets/skeleton_colors.dart';

class SkeletonBone extends StatelessWidget {
  const SkeletonBone({
    super.key,
    this.width,
    required this.height,
    required this.radius,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final baseColor = SkeletonColors.base(context);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
