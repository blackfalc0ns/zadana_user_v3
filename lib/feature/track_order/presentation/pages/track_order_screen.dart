import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_status_badge.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/manager/track_order_state.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/manager/track_order_view_model.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_driver_card.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_time_line.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key, required this.orderId});

  final String orderId;

  bool _isBrokenText(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return true;
    return RegExp(r'^\?+$').hasMatch(trimmed) ||
        RegExp(r'^[\?\s]+$').hasMatch(trimmed) ||
        trimmed.contains('�') ||
        trimmed.contains('Ù') ||
        trimmed.contains('Ø');
  }

  String _timelineFallbackLabel(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.order_pending;
      case 1:
        return l10n.track_order;
      case 2:
        return l10n.delivery_get_otp;
      default:
        return l10n.order_delivered;
    }
  }

  String _localizedTimelineTitle(
    AppLocalizations l10n,
    OrderTrackingTimelineItemEntity item,
    int index,
  ) {
    switch (item.id) {
      case 'order_placed':
        return l10n.track_order_order_placed;
      case 'vendor_confirmed':
        return l10n.track_order_vendor_confirmed;
      case 'preparing':
        return l10n.track_order_preparing;
      case 'out_for_delivery':
        return l10n.track_order_out_for_delivery;
      case 'delivered':
        return l10n.order_delivered;
      default:
        if (!_isBrokenText(item.title)) {
          return item.title;
        }
        return _timelineFallbackLabel(l10n, index);
    }
  }

  String _resolveEstimatedDeliveryText(
    BuildContext context,
    OrderEstimatedDeliveryEntity? estimatedDelivery,
  ) {
    if (estimatedDelivery == null) {
      return AppLocalizations.of(context)!.order_pending;
    }

    final dateTime = estimatedDelivery.dateTime;
    if (dateTime != null) {
      final locale = Localizations.localeOf(context).languageCode;
      return DateFormat(
        'dd MMM yyyy, hh:mm a',
        locale,
      ).format(dateTime.toLocal());
    }

    if (!_isBrokenText(estimatedDelivery.formatted)) {
      return estimatedDelivery.formatted;
    }

    return AppLocalizations.of(context)!.order_pending;
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar.modern(
        title: l10n.track_order,
        backgroundColor: color.surface,
        actions: [
          BlocBuilder<TrackOrderViewModel, TrackOrderState>(
            buildWhen: (previous, current) =>
                previous.isLive != current.isLive ||
                previous.isRefreshing != current.isRefreshing,
            builder: (context, state) {
              return IconButton(
                tooltip: l10n.refresh,
                onPressed: state.isRefreshing
                    ? null
                    : () => context.read<TrackOrderViewModel>().load(
                        isManualRefresh: true,
                      ),
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
          ),
        ],
      ),
      body: BlocConsumer<TrackOrderViewModel, TrackOrderState>(
        listenWhen: (previous, current) =>
            previous.failure != current.failure &&
            current.failure != null &&
            previous.orderTracking != null,
        listener: (context, state) {
          final failure = state.failure;
          if (failure == null) return;
          CustomSnackbar.showError(
            context: context,
            message: failure.errorMessage,
          );
        },
        builder: (context, state) {
          if (state.isLoading && state.orderTracking == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.failure != null && state.orderTracking == null) {
            return ApiErrorWidget.fromFailure(
              state.failure!,
              onRetry: () => context.read<TrackOrderViewModel>().load(),
            );
          }

          final tracking = state.orderTracking;
          if (tracking == null) {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<TrackOrderViewModel>().load(isManualRefresh: true);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Spacing.base),
              children: [
                SurfaceCard(
                  borderRadius: 24,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: color.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.local_shipping_outlined,
                          color: color.primary,
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              l10n.estimated_delivery,
                              textAlign: TextAlign.end,
                              style: getBoldStyle(
                                fontSize: FontSize.size15,
                                fontFamily: FontConstant.cairo,
                                color: color.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _resolveEstimatedDeliveryText(
                                context,
                                tracking.estimatedDelivery,
                              ),
                              textAlign: TextAlign.end,
                              style: getBoldStyle(
                                fontSize: FontSize.size18,
                                fontFamily: FontConstant.cairo,
                                color: color.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              alignment: WrapAlignment.end,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: Spacing.sm,
                              runSpacing: Spacing.sm,
                              children: [
                                OrderStatusBadge(status: tracking.order.status),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 220,
                                  ),
                                  child: Text(
                                    '${l10n.order_number}: ${tracking.order.id}',
                                    textAlign: TextAlign.end,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: getRegularStyle(
                                      fontFamily: FontConstant.cairo,
                                      color: color.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.base),
                if (tracking.driver?.hasContent ?? false) ...[
                  TrackOrderDriverCard(driver: tracking.driver!),
                  const SizedBox(height: Spacing.base),
                ],
                Container(
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: color.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: color.outline.withValues(alpha: .1),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/fast_delivery.svg',
                      height: 120,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.base),
                SurfaceCard(
                  borderRadius: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.track_order,
                              textAlign: TextAlign.end,
                              style: getBoldStyle(
                                fontSize: FontSize.size16,
                                fontFamily: FontConstant.cairo,
                                color: color.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.track_changes_rounded,
                            color: color.primary,
                            size: 22,
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.base),
                      ...tracking.timeline.asMap().entries.map((entry) {
                        final item = entry.value;
                        final safeTitle = _localizedTimelineTitle(
                          l10n,
                          item,
                          entry.key,
                        );
                        final safeTime = _isBrokenText(item.time)
                            ? ''
                            : item.time;

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: entry.key == tracking.timeline.length - 1
                                ? 0
                                : Spacing.sm,
                          ),
                          child: TrackOrderTimelineTile(
                            title: safeTitle,
                            time: safeTime,
                            active: item.isActive,
                            completed: item.isCompleted,
                            last: entry.key == tracking.timeline.length - 1,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.base),
                if (tracking.order.status.isActive)
                  AppButton.outlined(
                    text: l10n.delivery_get_otp,
                    icon: Icons.qr_code_rounded,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.deliveryOtp,
                      arguments: {'orderId': orderId},
                    ),
                    color: color.primary,
                    textColor: color.primary,
                  ),
                const SizedBox(height: Spacing.sm),
                AppButton(
                  text: l10n.back_to_home,
                  icon: Icons.home_outlined,
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.mainShell,
                    (route) => false,
                  ),
                  color: color.primary,
                  textColor: color.onPrimary,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
