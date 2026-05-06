import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_details_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_cards.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/support_case/support_case_formatters.dart';

class OrderDetailsBodyView extends StatelessWidget {
  const OrderDetailsBodyView({
    super.key,
    required this.order,
    required this.refundStatus,
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
  final OrderRefundStatusEntity? refundStatus;
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
    final activeSupportCase = order.activeCase;
    final showRefundStatusCard =
        refundStatus != null &&
        (refundStatus!.hasActiveCase ||
            refundStatus!.settlementStatus !=
                OrderSupportSettlementStatus.unknown ||
            (refundStatus!.couponCode?.trim().isNotEmpty ?? false));
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
                  title: supportCaseOperationalTypeLabel(
                    l10n,
                    type: activeSupportCase!.type,
                    status: activeSupportCase.status,
                    settlementStatus: OrderSupportSettlementStatus.unknown,
                  ),
                  status: activeSupportCase.status,
                  statusLabel: supportCaseMainStatusLabel(
                    l10n,
                    activeSupportCase.status,
                  ),
                  typeLabel: supportCaseOperationalTypeLabel(
                    l10n,
                    type: activeSupportCase.type,
                    status: activeSupportCase.status,
                    settlementStatus: OrderSupportSettlementStatus.unknown,
                  ),
                  typeMeta: supportCaseSanitizeVisibleText(
                    l10n,
                    activeSupportCase.message,
                    caseId: activeSupportCase.id,
                    fieldName: 'summary.message',
                  ),
                  message: activeSupportCase.message,
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
        if (showRefundStatusCard) ...[
          const SizedBox(height: Spacing.base),
          DetailSection(
            title: _isArabic(l10n)
                ? 'حالة الاسترجاع / الإرجاع'
                : 'Refund / Return Status',
            child: _RefundStatusCard(
              refundStatus: refundStatus!,
              money: money,
              onCopyCoupon: (code) async {
                await Clipboard.setData(ClipboardData(text: code));
                if (!context.mounted) return;
                CustomSnackbar.showSuccess(
                  context: context,
                  message: _isArabic(l10n) ? 'تم نسخ الكود' : 'Code copied',
                );
              },
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

  bool _isArabic(AppLocalizations l10n) =>
      l10n.localeName.toLowerCase().startsWith('ar');

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

class _RefundStatusCard extends StatelessWidget {
  const _RefundStatusCard({
    required this.refundStatus,
    required this.money,
    required this.onCopyCoupon,
  });

  final OrderRefundStatusEntity refundStatus;
  final String Function(double value) money;
  final ValueChanged<String> onCopyCoupon;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final couponCode = refundStatus.couponCode?.trim() ?? '';
    final note = refundStatus.customerNote?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SummaryRow(
          label: isArabic ? 'النتيجة' : 'Result',
          value: _settlementLabel(refundStatus.settlementStatus, isArabic),
          emphasized: true,
        ),
        if (refundStatus.approvedAmount != null) ...[
          const SizedBox(height: Spacing.sm),
          SummaryRow(
            label: isArabic ? 'المبلغ المعتمد' : 'Approved amount',
            value: money(refundStatus.approvedAmount!),
          ),
        ],
        if (refundStatus.requestedAmount != null) ...[
          const SizedBox(height: Spacing.sm),
          SummaryRow(
            label: isArabic ? 'المبلغ المطلوب' : 'Requested amount',
            value: money(refundStatus.requestedAmount!),
          ),
        ],
        if ((refundStatus.refundMethod?.trim().isNotEmpty ?? false)) ...[
          const SizedBox(height: Spacing.sm),
          SummaryRow(
            label: isArabic ? 'طريقة التعويض' : 'Settlement method',
            value: _humanize(refundStatus.refundMethod!),
          ),
        ],
        if (couponCode.isNotEmpty) ...[
          const SizedBox(height: Spacing.base),
          DecoratedBlock(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SummaryRow(
                  label: isArabic ? 'كود الكوبون' : 'Coupon code',
                  value: couponCode,
                  emphasized: true,
                ),
                if (refundStatus.couponExpiresAt != null) ...[
                  const SizedBox(height: Spacing.sm),
                  SummaryRow(
                    label: isArabic ? 'ينتهي في' : 'Expires at',
                    value: _formatDate(refundStatus.couponExpiresAt!, isArabic),
                  ),
                ],
                const SizedBox(height: Spacing.sm),
                SummaryRow(
                  label: isArabic ? 'تم الاستخدام' : 'Redeemed',
                  value: refundStatus.couponRedeemed
                      ? (isArabic ? 'نعم' : 'Yes')
                      : (isArabic ? 'لا' : 'No'),
                ),
                const SizedBox(height: Spacing.sm),
                AppButton.outlined(
                  text: isArabic ? 'نسخ الكود' : 'Copy code',
                  onPressed: () => onCopyCoupon(couponCode),
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
        if (note.isNotEmpty) ...[
          const SizedBox(height: Spacing.base),
          SecondaryText(note),
        ],
      ],
    );
  }

  static String _settlementLabel(
    OrderSupportSettlementStatus status,
    bool isArabic,
  ) {
    switch (status) {
      case OrderSupportSettlementStatus.pendingReview:
        return isArabic ? 'الطلب قيد المراجعة' : 'Pending review';
      case OrderSupportSettlementStatus.cashRefunded:
        return isArabic ? 'تم استرجاع المبلغ' : 'Cash refunded';
      case OrderSupportSettlementStatus.couponIssued:
        return isArabic ? 'تم إصدار كوبون تعويضي' : 'Coupon issued';
      case OrderSupportSettlementStatus.couponRedeemed:
        return isArabic ? 'تم استخدام الكوبون' : 'Coupon redeemed';
      case OrderSupportSettlementStatus.rejected:
        return isArabic ? 'تم رفض الطلب' : 'Rejected';
      case OrderSupportSettlementStatus.approved:
        return isArabic ? 'تمت الموافقة' : 'Approved';
      case OrderSupportSettlementStatus.unknown:
        return isArabic ? 'لا توجد بيانات' : 'No status';
    }
  }

  static String _humanize(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  static String _formatDate(DateTime dateTime, bool isArabic) {
    final local = dateTime.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final value = '${local.year}-$month-$day $hour:$minute';
    return isArabic ? value : value;
  }
}
