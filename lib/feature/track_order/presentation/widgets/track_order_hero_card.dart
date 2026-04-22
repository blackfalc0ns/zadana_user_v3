import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

class TrackOrderHeroCard extends StatelessWidget {
  const TrackOrderHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.outline.withValues(alpha: .1)),
      ),
      child: Center(
        child: SvgPicture.asset('assets/images/fast_delivery.svg', height: 120),
      ),
    );
  }
}
