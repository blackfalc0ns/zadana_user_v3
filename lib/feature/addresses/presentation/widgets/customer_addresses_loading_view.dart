import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/skeleton_state_widget.dart';

class CustomerAddressesLoadingView extends StatelessWidget {
  const CustomerAddressesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Spacing.base,
        Spacing.base,
        Spacing.base,
        110,
      ),
      children: [
        const SkeletonStateWidget(child: _SummarySkeleton()),
        const SizedBox(height: Spacing.base),
        for (var i = 0; i < 3; i++) ...[
          const SkeletonStateWidget(child: _AddressCardSkeleton()),
          const SizedBox(height: Spacing.md),
        ],
      ],
    );
  }
}

class _SummarySkeleton extends StatelessWidget {
  const _SummarySkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(26),
      ),
      child: const Row(
        children: [
          _SkeletonBox(width: 56, height: 56, radius: 18),
          SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(width: 180, height: 18, radius: 8),
                SizedBox(height: 10),
                _SkeletonBox(width: 140, height: 14, radius: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressCardSkeleton extends StatelessWidget {
  const _AddressCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SkeletonBox(width: 42, height: 42, radius: 14),
              SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(width: 96, height: 16, radius: 8),
                    SizedBox(height: 8),
                    _SkeletonBox(width: 120, height: 12, radius: 8),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Spacing.sm),
          _SkeletonBox(width: double.infinity, height: 14, radius: 8),
          SizedBox(height: 8),
          _SkeletonBox(width: 220, height: 14, radius: 8),
          SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: _SkeletonBox(
                  width: double.infinity,
                  height: 42,
                  radius: 12,
                ),
              ),
              SizedBox(width: Spacing.sm),
              Expanded(
                child: _SkeletonBox(
                  width: double.infinity,
                  height: 42,
                  radius: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE7E7E7),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
