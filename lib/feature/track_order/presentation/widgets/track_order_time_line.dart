import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';

class TrackOrderTimelineTile extends StatelessWidget {
  const TrackOrderTimelineTile({
    super.key,
    required this.title,
    required this.time,
    required this.active,
    required this.completed,
    required this.last,
  });

  final String title;
  final String time;
  final bool active;
  final bool completed;
  final bool last;

  Color _indicatorColor(ColorScheme color) {
    if (completed || active) return color.primary;
    return const Color(0xFFE58E1A);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final indicatorColor = _indicatorColor(color);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.end,
                  style: getMediumStyle(
                    fontSize: 18,
                    fontFamily: FontConstant.cairo,
                    color: completed || active
                        ? color.onSurface
                        : const Color(0xFFE58E1A),
                  ),
                ),
                if (time.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    time,
                    textAlign: TextAlign.end,
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
        ),
        const SizedBox(width: 14),
        Column(
          children: [
            Icon(
              completed || active
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: indicatorColor,
              size: 28,
            ),
            if (!last)
              Container(
                width: 2,
                height: 56,
                color: completed || active
                    ? color.primary.withValues(alpha: .55)
                    : const Color(0xFFE58E1A).withValues(alpha: .4),
              ),
          ],
        ),
      ],
    );
  }
}
