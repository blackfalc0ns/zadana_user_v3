import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_status_badge.dart';

enum OrderComplaintState { none, submitted, inReview, resolved }

String complaintStatusLabel(OrderComplaintState state) {
  switch (state) {
    case OrderComplaintState.none:
      return '';
    case OrderComplaintState.submitted:
      return 'تم استلام الشكوى';
    case OrderComplaintState.inReview:
      return 'الشكوى تحت المراجعة';
    case OrderComplaintState.resolved:
      return 'تم حل الشكوى';
  }
}

class OrderHeaderCard extends StatelessWidget {
  const OrderHeaderCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.date,
    required this.itemCount,
    required this.total,
  });

  final String orderId;
  final OrderStatus status;
  final String date;
  final int itemCount;
  final String total;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'طلب #$orderId',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'تم الإنشاء بتاريخ $date',
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              OrderStatusBadge(status: status),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: _MetaPill(
                  icon: Icons.inventory_2_outlined,
                  label: 'عدد المنتجات',
                  value: '$itemCount',
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: _MetaPill(
                  icon: Icons.payments_outlined,
                  label: 'الإجمالي',
                  value: total,
                  highlighted: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tone = highlighted ? colors.primary : colors.secondary;
    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: highlighted
            ? colors.primary.withValues(alpha: .08)
            : colors.secondary.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: .92),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: tone),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: colors.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.w800, color: tone),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailSection extends StatelessWidget {
  const DetailSection({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: Spacing.md),
          child,
        ],
      ),
    );
  }
}

class OrderSummaryGrid extends StatelessWidget {
  const OrderSummaryGrid({
    super.key,
    required this.itemCount,
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  final int itemCount;
  final String subtotal;
  final String shipping;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SummaryRow(label: 'عدد القطع', value: '$itemCount'),
        const SizedBox(height: Spacing.sm),
        _SummaryRow(label: 'المجموع الفرعي', value: subtotal),
        const SizedBox(height: Spacing.sm),
        _SummaryRow(label: 'الشحن', value: shipping),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: Spacing.sm),
          child: Divider(height: 1),
        ),
        _SummaryRow(label: 'الإجمالي', value: total, emphasized: true),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: emphasized ? colors.onSurface : colors.onSurfaceVariant,
              fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: emphasized ? colors.primary : colors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({
    super.key,
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String name;
  final int quantity;
  final String price;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '$quantity x',
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  'سعر القطعة: $price',
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: colors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class ComplaintStatusCard extends StatelessWidget {
  const ComplaintStatusCard({
    super.key,
    required this.title,
    required this.message,
    this.attachments = const [],
  });

  final String title;
  final String message;
  final List<PlatformFile> attachments;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.support_agent_outlined, color: colors.secondary),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                ],
                if (attachments.isNotEmpty) ...[
                  const SizedBox(height: Spacing.sm),
                  ComplaintAttachmentsPreview(attachments: attachments),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ComplaintAttachmentsPreview extends StatelessWidget {
  const ComplaintAttachmentsPreview({super.key, required this.attachments});

  final List<PlatformFile> attachments;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Wrap(
      spacing: Spacing.xs,
      runSpacing: Spacing.xs,
      children: attachments
          .map(
            (file) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: .2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.image_outlined, size: 16, color: colors.secondary),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class OrderDetailsActions extends StatelessWidget {
  const OrderDetailsActions({
    super.key,
    required this.canCancel,
    required this.hasComplaint,
    required this.onCancel,
    required this.onComplaint,
  });

  final bool canCancel;
  final bool hasComplaint;
  final VoidCallback onCancel;
  final VoidCallback onComplaint;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        if (canCancel)
          Expanded(
            child: AppButton.outlined(
              text: 'إلغاء الطلب',
              color: AppColors.error,
              textColor: AppColors.error,
              height: 50,
              borderRadius: 18,
              onPressed: onCancel,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (canCancel) const SizedBox(width: Spacing.sm),
        Expanded(
          child: AppButton(
            text: hasComplaint ? 'متابعة' : 'تقديم شكوى',
            variant: hasComplaint
                ? AppButtonVariant.outlined
                : AppButtonVariant.filled,
            color: colors.primary,
            height: 50,
            borderRadius: 18,
            fontWeight: FontWeight.w600,
            onPressed: onComplaint,
          ),
        ),
      ],
    );
  }
}

class OrderMiniCard extends StatelessWidget {
  const OrderMiniCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.total,
  });

  final String orderId;
  final OrderStatus status;
  final String total;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رقم الطلب: $orderId',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                OrderStatusBadge(status: status),
              ],
            ),
          ),
          Text(
            total,
            style: TextStyle(
              color: colors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomSheetScaffold extends StatelessWidget {
  const BottomSheetScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.body,
    required this.secondaryActionLabel,
    required this.primaryActionLabel,
    required this.onSecondaryTap,
    required this.onPrimaryTap,
    this.primaryColor,
  });

  final String title;
  final String subtitle;
  final Widget summary;
  final Widget body;
  final String secondaryActionLabel;
  final String primaryActionLabel;
  final VoidCallback onSecondaryTap;
  final VoidCallback? onPrimaryTap;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        Spacing.base,
        Spacing.sm,
        Spacing.base,
        MediaQuery.of(context).viewInsets.bottom + Spacing.base,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.outlineVariant.withValues(alpha: .5),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: Spacing.base),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Center(
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: Spacing.base),
            summary,
            const SizedBox(height: Spacing.base),
            body,
            const SizedBox(height: Spacing.base),
            Row(
              children: [
                Expanded(
                  child: AppButton.outlined(
                    text: secondaryActionLabel,
                    onPressed: onSecondaryTap,
                    height: 54,
                    borderRadius: 18,
                    color: colors.outline,
                    textColor: colors.onSurface,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: AppButton(
                    text: primaryActionLabel,
                    onPressed: onPrimaryTap,
                    height: 54,
                    borderRadius: 18,
                    color: primaryColor ?? colors.primary,
                    textColor: colors.onPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SheetTextField extends StatelessWidget {
  const SheetTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 3,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: colors.surfaceContainerHighest.withValues(alpha: .22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class CancelReasonTile extends StatelessWidget {
  const CancelReasonTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: Spacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? colors.primary
                : colors.outlineVariant.withValues(alpha: .25),
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? colors.primary : colors.outline,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
      ),
    );
  }
}
