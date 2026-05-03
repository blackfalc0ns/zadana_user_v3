import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_details_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_cards.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_shared.dart';

class OrderDetailsBodyView extends StatelessWidget {
  const OrderDetailsBodyView({
    super.key,
    required this.order,
    required this.status,
    required this.isBusy,
    required this.isCancelling,
    required this.isRetryingPayment,
    required this.isDeleting,
    required this.isSubmittingSupportCase,
    required this.onTrackOrder,
    required this.onCancel,
    required this.onRetryPayment,
    required this.onSupportCase,
  });

  final OrderDetailsEntity order;
  final OrderStatus status;
  final bool isBusy;
  final bool isCancelling;
  final bool isRetryingPayment;
  final bool isDeleting;
  final bool isSubmittingSupportCase;
  final VoidCallback onTrackOrder;
  final VoidCallback onCancel;
  final VoidCallback onRetryPayment;
  final VoidCallback onSupportCase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasActiveSupportCase = order.activeCase != null;
    final canShowSupportAction =
        hasActiveSupportCase ||
        status.canCreateComplaint ||
        status.canCreateReturnRequest;
    final showBottomSupportAction =
        !hasActiveSupportCase && canShowSupportAction;
    final canShowActions =
        order.canCancel || order.canRetryPayment || showBottomSupportAction;
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
        if (hasActiveSupportCase) ...[
          const SizedBox(height: Spacing.base),
          DetailSection(
            title: l10n.my_orders_support_case_title,
            child: Column(
              children: [
                ActiveSupportCaseCard(
                  title: _supportCaseHeadline(l10n, order.activeCase!.status),
                  status: order.activeCase!.status,
                  typeLabel: '',
                  message: order.activeCase!.message,
                ),
                const SizedBox(height: Spacing.sm),
                AppButton.outlined(
                  text: l10n.my_orders_support_case_view,
                  onPressed: onSupportCase,
                  height: 42,
                  borderRadius: 14,
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ],
        if (canShowActions) ...[
          const SizedBox(height: Spacing.lg),
          OrderDetailsActions(
            canCancel: order.canCancel,
            canRetryPayment: order.canRetryPayment,
            showSupportAction: showBottomSupportAction,
            isCancelling: isCancelling,
            isRetryingPayment: isRetryingPayment,
            isSupportCaseBusy: isSubmittingSupportCase,
            onCancel: onCancel,
            onRetryPayment: onRetryPayment,
            onSupportCase: onSupportCase,
          ),
          const SizedBox(height: Spacing.base),
        ],
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

  String _supportCaseHeadline(
    AppLocalizations l10n,
    OrderSupportCaseStatus status,
  ) {
    final isArabic = l10n.localeName.toLowerCase().startsWith('ar');

    switch (status) {
      case OrderSupportCaseStatus.submitted:
        return isArabic ? 'تم فتح الحالة' : 'Case Opened';
      case OrderSupportCaseStatus.inReview:
        return isArabic ? 'قيد المتابعة' : 'Under Review';
      case OrderSupportCaseStatus.awaitingCustomerEvidence:
        return isArabic ? 'نحتاج تفاصيل' : 'More Details Needed';
      case OrderSupportCaseStatus.approved:
        return isArabic ? 'تمت الموافقة' : 'Approved';
      case OrderSupportCaseStatus.rejected:
        return isArabic ? 'تم رفض الحالة' : 'Rejected';
      case OrderSupportCaseStatus.resolved:
        return isArabic ? 'تمت المعالجة' : 'Resolved';
      case OrderSupportCaseStatus.unknown:
        return supportCaseStatusLabel(l10n, status);
    }
  }
}
