import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_cards.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/support_case/support_case_formatters.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/manager/track_order_view_model.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_actions_section.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_delivery_otp_card.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_driver_card.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_pickup_cards.dart';
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
    final isResendingPickupOtp = context.select(
      (TrackOrderViewModel cubit) => cubit.state.isResendingPickupOtp,
    );

    return RefreshIndicator(
      onRefresh: () async => viewModel.refresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(Spacing.base),
        children: [
          TrackOrderSummaryCard(
            tracking: tracking,
            estimatedDeliveryText: tracking.isPickup
                ? _pickupStatusText(context, tracking)
                : viewModel.resolveEstimatedDeliveryText(
                    l10n: l10n,
                    localeCode: localeCode,
                    estimatedDelivery: tracking.estimatedDelivery,
                  ),
          ),
          const SizedBox(height: Spacing.base),
          if (tracking.pickupBranch != null) ...[
            TrackOrderPickupBranchCard(branch: tracking.pickupBranch!),
            const SizedBox(height: Spacing.base),
          ],
          if (!tracking.isPickup &&
              ((tracking.assignedDriver?.hasContent ?? false) ||
                  (tracking.driver?.hasContent ?? false))) ...[
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
          if (tracking.activeCase != null) ...[
            _TrackOrderActiveSupportCaseSection(
              orderId: orderId,
              activeCase: tracking.activeCase!,
            ),
            const SizedBox(height: Spacing.base),
          ],
          if (tracking.shouldShowPickupOtp) ...[
            TrackOrderPickupOtpCard(
              tracking: tracking,
              isResending: isResendingPickupOtp,
              onResend: () async {
                final success = await viewModel.resendPickupOtp();
                if (!context.mounted) return;
                final isArabic =
                    Localizations.localeOf(context).languageCode == 'ar';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? (isArabic
                                ? 'أرسلنا كود الاستلام من جديد'
                                : 'Pickup code resent successfully')
                          : (isArabic
                                ? 'تعذر إعادة إرسال كود الاستلام'
                                : 'Could not resend pickup code'),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: Spacing.base),
          ],
          if (!tracking.isPickup && tracking.showDeliveryOtp) ...[
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

String _pickupStatusText(BuildContext context, OrderTrackingEntity tracking) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  switch (tracking.order.status) {
    case OrderStatus.delivered:
      return isArabic ? 'تم الاستلام' : 'Picked up';
    case OrderStatus.cancelled:
    case OrderStatus.vendorRejected:
    case OrderStatus.deliveryFailed:
      return isArabic ? 'ملغي' : 'Cancelled';
    case OrderStatus.processing:
      return tracking.shouldShowPickupOtp
          ? (isArabic ? 'جاهز للاستلام' : 'Ready for pickup')
          : (isArabic ? 'جاري تجهيز الطلب' : 'Preparing order');
    case OrderStatus.pending:
      return isArabic ? 'بانتظار تأكيد المتجر' : 'Waiting for vendor';
    case OrderStatus.returning:
      return isArabic ? 'قيد المعالجة' : 'In progress';
    case OrderStatus.shipped:
    case OrderStatus.unknown:
      return isArabic ? 'قيد المتابعة' : 'In progress';
  }
}

class _TrackOrderActiveSupportCaseSection extends StatelessWidget {
  const _TrackOrderActiveSupportCaseSection({
    required this.orderId,
    required this.activeCase,
  });

  final String orderId;
  final OrderSupportCaseSummaryEntity activeCase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final typeLabel = supportCaseOperationalTypeLabel(
      l10n,
      type: activeCase.type,
      status: activeCase.status,
      settlementStatus: OrderSupportSettlementStatus.unknown,
    );

    return DetailSection(
      title: l10n.my_orders_support_case_title,
      child: ActiveSupportCaseCard(
        title: typeLabel,
        message: activeCase.message,
        status: activeCase.status,
        typeLabel: typeLabel,
        orderNumber: activeCase.displayOrderNumber,
        typeMeta: supportCaseSanitizeVisibleText(
          l10n,
          activeCase.message,
          caseId: activeCase.id,
          fieldName: 'tracking.activeCase.message',
        ),
        statusLabel: supportCaseMainStatusLabel(l10n, activeCase.status),
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.orderSupportCase,
          arguments: {'orderId': orderId, 'caseId': activeCase.id},
        ),
      ),
    );
  }
}
