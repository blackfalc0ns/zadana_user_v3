import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/manager/track_order_view_model.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_time_line.dart';

class TrackOrderTimelineSection extends StatelessWidget {
  const TrackOrderTimelineSection({super.key, required this.tracking});

  final OrderTrackingEntity tracking;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.read<TrackOrderViewModel>();
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final localeCode = Localizations.localeOf(context).languageCode;

    return SurfaceCard(
      borderRadius: 28,
      padding: const EdgeInsets.fromLTRB(
        Spacing.base,
        Spacing.base,
        Spacing.base,
        Spacing.md,
      ),
      child: Column(
        crossAxisAlignment: isRtl
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Icon(Icons.track_changes_rounded, color: color.primary, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Align(
                  alignment: isRtl
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    l10n.track_order,
                    textAlign: isRtl ? TextAlign.end : TextAlign.start,
                    style: getBoldStyle(
                      fontSize: FontSize.size16,
                      fontFamily: FontConstant.cairo,
                      color: color.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          ...tracking.timeline.asMap().entries.map((entry) {
            final item = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: entry.key == tracking.timeline.length - 1
                    ? 0
                    : Spacing.md,
              ),
              child: TrackOrderTimelineTile(
                title: viewModel.localizedTimelineTitle(l10n, item, entry.key),
                time: viewModel.sanitizeTimelineTime(
                  item.time,
                  localeCode: localeCode,
                ),
                active: item.isActive,
                completed: item.isCompleted,
                last: entry.key == tracking.timeline.length - 1,
              ),
            );
          }),
        ],
      ),
    );
  }
}
