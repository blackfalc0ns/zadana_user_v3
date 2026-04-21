import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_details_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_cards.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_shared.dart';

class OrderDetailsBodyView extends StatelessWidget {
  const OrderDetailsBodyView({
    super.key,
    required this.order,
    required this.complaint,
    required this.message,
    required this.attachments,
    required this.status,
    required this.isBusy,
    required this.isCancelling,
    required this.isRetryingPayment,
    required this.isDeleting,
    required this.onTrackOrder,
    required this.onCancel,
    required this.onRetryPayment,
    required this.onComplaint,
  });

  final OrderDetailsEntity order;
  final OrderComplaintState complaint;
  final String message;
  final List<PlatformFile> attachments;
  final OrderStatus status;
  final bool isBusy;
  final bool isCancelling;
  final bool isRetryingPayment;
  final bool isDeleting;
  final VoidCallback onTrackOrder;
  final VoidCallback onCancel;
  final VoidCallback onRetryPayment;
  final VoidCallback onComplaint;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final createdAt =
        '${order.createdAt.year}-${order.createdAt.month.toString().padLeft(2, '0')}-${order.createdAt.day.toString().padLeft(2, '0')}';

    String money(double value) =>
        '${value.toStringAsFixed(2)} ${l10n.currency}';

    return ListView(
      padding: const EdgeInsets.all(Spacing.base),
      children: [
        OrderHeaderCard(
          status: status,
          date: createdAt,
          itemCount: order.itemsCount,
          total: money(order.totalPrice),
        ),
        if (status.isActive && !order.canRetryPayment) ...[
          const SizedBox(height: Spacing.base),
          FilledButton.icon(
            onPressed: onTrackOrder,
            icon: const Icon(Icons.location_on_outlined, size: 20),
            label: Text(l10n.track_order),
          ),
        ],
        const SizedBox(height: Spacing.base),
        DetailSection(
          title: l10n.my_orders_order_summary_title,
          child: OrderSummaryGrid(
            itemCount: order.itemsCount,
            subtotal: money(order.summary.subtotal),
            shipping: money(order.summary.shippingCost),
            total: money(order.summary.total),
          ),
        ),
        const SizedBox(height: Spacing.base),
        DetailSection(
          title: l10n.my_orders_delivery_otp_title,
          child: Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.deliveryOtp,
                  arguments: {'orderId': order.id},
                ),
                icon: const Icon(Icons.visibility_outlined, size: 20),
                label: Text(l10n.my_orders_view_otp),
              ),
            ),
          ),
        ),
        const SizedBox(height: Spacing.base),
        DetailSection(
          title: l10n.my_orders_items,
          child: Column(
            children: order.items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.sm),
                    child: OrderItemTile(
                      name: item.name,
                      quantity: item.quantity,
                      price: money(item.price),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        if (complaint != OrderComplaintState.none) ...[
          const SizedBox(height: Spacing.base),
          DetailSection(
            title: l10n.my_orders_complaint_status_title,
            child: ComplaintStatusCard(
              title: complaintStatusLabel(l10n, complaint),
              message: message,
              attachments: attachments,
            ),
          ),
        ],
        const SizedBox(height: Spacing.lg),
        OrderDetailsActions(
          canCancel: order.canCancel,
          canRetryPayment: order.canRetryPayment,
          hasComplaint: complaint != OrderComplaintState.none,
          isCancelling: isCancelling,
          isRetryingPayment: isRetryingPayment,
          isComplaintBusy: isDeleting,
          onCancel: onCancel,
          onRetryPayment: onRetryPayment,
          onComplaint: onComplaint,
        ),
        const SizedBox(height: Spacing.base),
      ],
    );
  }
}
