import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';

class TrackOrderDriverCard extends StatelessWidget {
  const TrackOrderDriverCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.base),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest.withValues(alpha: .35),
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.primary.withValues(alpha: .12),
            child: Icon(Icons.person_rounded, color: color.primary, size: 26),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '????',
                  style: getMediumStyle(
                    fontSize: 16,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '????? ??????? ????? ?????',
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: color.secondary.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.call_outlined, color: color.secondary),
          ),
        ],
      ),
    );
  }
}
