import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
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

  bool get _isCurrent => active;
  bool get _isCompleted => completed && !active;

  Color _indicatorColor(ColorScheme color) {
    if (_isCurrent) return color.primary;
    if (_isCompleted) return color.primary.withValues(alpha: .55);
    return color.onSurfaceVariant.withValues(alpha: .45);
  }

  Color _titleColor(ColorScheme color) {
    if (_isCurrent) return color.onSurface;
    if (_isCompleted) return color.onSurface.withValues(alpha: .7);
    return color.onSurface.withValues(alpha: .5);
  }

  IconData _indicatorIcon() {
    if (_isCurrent) {
      return Icons.radio_button_checked_rounded;
    }
    if (_isCompleted) return Icons.check_circle_rounded;
    return Icons.radio_button_off_rounded;
  }

  String _displayTime(BuildContext context) {
    final normalized = time.trim();
    if (normalized.isEmpty) return normalized;

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (!isArabic) return normalized;

    final upper = normalized.toUpperCase();
    final suffixPattern = RegExp(r'^(\d{1,2}:\d{2})\s*(AM|PM)$');
    final prefixPattern = RegExp(r'^(AM|PM)\s*(\d{1,2}:\d{2})$');

    final suffixMatch = suffixPattern.firstMatch(upper);
    if (suffixMatch != null) {
      final clock = suffixMatch.group(1)!;
      final period = suffixMatch.group(2) == 'AM' ? 'ص' : 'م';
      return '$clock $period';
    }

    final prefixMatch = prefixPattern.firstMatch(upper);
    if (prefixMatch != null) {
      final period = prefixMatch.group(1) == 'AM' ? 'ص' : 'م';
      final clock = prefixMatch.group(2)!;
      return '$clock $period';
    }

    return normalized;
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final indicatorColor = _indicatorColor(color);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final shouldShowTime = (_isCurrent || _isCompleted) && time.isNotEmpty;
    final displayTime = _displayTime(context);

    final timelineColumn = SizedBox(
      width: 28,
      child: Column(
        children: [
          Icon(_indicatorIcon(), color: indicatorColor, size: 28),
          if (!last)
            Container(
              width: 3,
              height: shouldShowTime ? 62 : 54,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: _isCompleted
                    ? color.primary.withValues(alpha: .45)
                    : color.onSurfaceVariant.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
        ],
      ),
    );

    final timelineContent = Flexible(
      child: Align(
        alignment: isRtl ? Alignment.topRight : Alignment.topLeft,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isRtl
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: isRtl ? TextAlign.end : TextAlign.start,
                style: getMediumStyle(
                  fontSize: 18,
                  fontFamily: FontConstant.cairo,
                  color: _titleColor(color),
                ),
              ),
              if (shouldShowTime) ...[
                const SizedBox(height: 4),
                Align(
                  alignment: isRtl
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.primary.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      displayTime,
                      textAlign: isRtl ? TextAlign.end : TextAlign.start,
                      style: getRegularStyle(
                        fontSize: 13,
                        fontFamily: FontConstant.cairo,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      children: [timelineColumn, const SizedBox(width: 4), timelineContent],
    );
  }
}
