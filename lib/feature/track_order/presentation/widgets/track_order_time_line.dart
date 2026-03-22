import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';

class TrackOrderTimelineTile extends StatelessWidget {
  const TrackOrderTimelineTile({
    super.key,
    required this.title,
    required this.time,
    required this.active,
    required this.last,
  });

  final String title;
  final String time;
  final bool active;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              active
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: active ? color.primary : color.secondary,
              size: 28,
            ),
            if (!last)
              Container(
                width: 2,
                height: 56,
                color: active
                    ? color.primary.withValues(alpha: .55)
                    : color.secondary.withValues(alpha: .45),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: getMediumStyle(
                  fontSize: 18,
                  fontFamily: FontConstant.cairo,
                  color: active ? color.primary : color.secondary,
                ),
              ),
              if (active) ...[
                const SizedBox(height: 4),
                Text(
                  time,
                  style: getRegularStyle(
                    fontSize: 14,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
