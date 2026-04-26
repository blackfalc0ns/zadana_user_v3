import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
          title: l10n.payment_method,
          child: OrderPaymentSummary(
            methodLabel: _paymentMethodLabel(l10n, order.paymentMethod),
            statusLabel: _paymentStatusLabel(l10n, order.paymentStatus),
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

  String _paymentMethodLabel(AppLocalizations l10n, String paymentMethod) {
    switch (paymentMethod.trim().toLowerCase()) {
      case 'card':
      case 'credit_card':
      case 'creditcard':
      case 'debit_card':
      case 'debitcard':
        return l10n.credit_debit_card;
      case 'cash':
      case 'cash_on_delivery':
      case 'cod':
        return l10n.cash_on_delivery;
      default:
        return _humanize(paymentMethod);
    }
  }

  String _paymentStatusLabel(AppLocalizations l10n, String paymentStatus) {
    switch (paymentStatus.trim().toLowerCase()) {
      case 'paid':
      case 'success':
      case 'succeeded':
        return 'Paid';
      case 'pending':
      case 'processing':
        return l10n.order_pending;
      case 'failed':
      case 'unpaid':
        return 'Unpaid';
      default:
        return _humanize(paymentStatus);
    }
  }

  String _humanize(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return '-';

    final words = normalized
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        );
    return words.join(' ');
  }
}
