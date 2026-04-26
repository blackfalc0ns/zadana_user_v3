import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';

class TrackOrderHeroCard extends StatelessWidget {
  const TrackOrderHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return SurfaceCard(
      borderRadius: 28,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.md,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Spacing.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.primary.withValues(alpha: .05),
              color.secondary.withValues(alpha: .04),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/images/fast_delivery.svg',
            height: 112,
          ),
        ),
      ),
    );
  }
}
