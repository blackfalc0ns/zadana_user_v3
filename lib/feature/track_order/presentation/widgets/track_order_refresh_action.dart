import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/manager/track_order_state.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/manager/track_order_view_model.dart';

class TrackOrderRefreshAction extends StatelessWidget {
  const TrackOrderRefreshAction({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<TrackOrderViewModel, TrackOrderState>(
      buildWhen: (previous, current) =>
          previous.isLive != current.isLive ||
          previous.isRefreshing != current.isRefreshing,
      builder: (context, state) {
        return IconButton(
          tooltip: l10n.refresh,
          onPressed: state.isRefreshing
              ? null
              : context.read<TrackOrderViewModel>().refresh,
          icon: state.isLive
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.refresh,
                    style: getBoldStyle(
                      fontSize: 11,
                      fontFamily: FontConstant.cairo,
                      color: color.primary,
                    ),
                  ),
                )
              : const Icon(Icons.refresh_rounded),
        );
      },
    );
  }
}
