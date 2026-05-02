import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/repo/my_orders_repository.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_support_case_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/pages/order_support_case_page.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_cards.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_shared.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/manager/track_order_view_model.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_actions_section.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_delivery_otp_card.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_driver_card.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_summary_card.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_timeline_section.dart';

class TrackOrderContent extends StatelessWidget {
  const TrackOrderContent({
    super.key,
    required this.orderId,
    required this.tracking,
  });

  final String orderId;
  final OrderTrackingEntity tracking;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;
    final viewModel = context.read<TrackOrderViewModel>();
    Future<void> openSupportCase() async {
      final activeCaseId = tracking.activeCase?.id;
      if (activeCaseId == null || activeCaseId.isEmpty) {
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => OrderSupportCaseViewModel(
              getIt<MyOrdersRepository>(),
              getIt<NotificationsSignalRService>(),
            )..initialize(orderId, initialCaseId: activeCaseId),
            child: OrderSupportCasePage(
              orderId: orderId,
              initialCaseId: activeCaseId,
            ),
          ),
        ),
      );

      if (context.mounted) {
        viewModel.refresh();
      }
    }

    return RefreshIndicator(
      onRefresh: () async => viewModel.refresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(Spacing.base),
        children: [
          TrackOrderSummaryCard(
            tracking: tracking,
            estimatedDeliveryText: viewModel.resolveEstimatedDeliveryText(
              l10n: l10n,
              localeCode: localeCode,
              estimatedDelivery: tracking.estimatedDelivery,
            ),
          ),
          const SizedBox(height: Spacing.base),
          if (tracking.activeCase != null) ...[
            DetailSection(
              title: l10n.my_orders_support_case_title,
              child: ActiveSupportCaseCard(
                title: supportCaseStatusLabel(l10n, tracking.activeCase!.status),
                status: tracking.activeCase!.status,
                typeLabel: supportCaseTypeLabel(l10n, tracking.activeCase!.type),
                message: tracking.activeCase!.message,
                onTap: openSupportCase,
              ),
            ),
            const SizedBox(height: Spacing.base),
          ],
          if ((tracking.assignedDriver?.hasContent ?? false) ||
              (tracking.driver?.hasContent ?? false)) ...[
            TrackOrderDriverCard(
              driver: tracking.driver,
              assignedDriver: tracking.assignedDriver,
              arrivalStateLabel: viewModel.resolveDriverArrivalStateLabel(
                l10n,
                tracking.driverArrivalState,
              ),
            ),
            const SizedBox(height: Spacing.base),
          ],
          if (tracking.showDeliveryOtp) ...[
            TrackOrderDeliveryOtpCard(
              onViewOtp: () => Navigator.pushNamed(
                context,
                AppRoutes.deliveryOtp,
                arguments: {
                  'orderId': orderId,
                  'phoneNumber':
                      tracking.assignedDriver?.phoneNumber ??
                      tracking.driver?.phoneNumber ??
                      '',
                  'courierName':
                      tracking.assignedDriver?.name ?? tracking.driver?.name,
                  'otpCode': tracking.deliveryOtp,
                },
              ),
            ),
            const SizedBox(height: Spacing.base),
          ],
          // const TrackOrderHeroCard(),
          const SizedBox(height: Spacing.base),
          TrackOrderTimelineSection(tracking: tracking),
          const SizedBox(height: Spacing.base),
          TrackOrderActionsSection(orderId: orderId, tracking: tracking),
        ],
      ),
    );
  }
}
