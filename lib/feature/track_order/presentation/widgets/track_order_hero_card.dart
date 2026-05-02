import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

class TrackOrderHeroCard extends StatelessWidget {
  const TrackOrderHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.surface,
        border: Border.all(color: color.outlineVariant.withValues(alpha: .16)),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: .04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
          color: color.surfaceContainerHighest.withValues(alpha: .12),
          child: Center(
            child: SvgPicture.asset(
              'assets/images/fast_delivery.svg',
              height: 78,
            ),
          ),
        ),
      ),
    );
  }
}
