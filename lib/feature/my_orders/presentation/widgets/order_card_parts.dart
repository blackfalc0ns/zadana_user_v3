import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_status_badge.dart';

String formatOrderDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

class OrderCardHeader extends StatelessWidget {
  const OrderCardHeader({super.key, required this.order, required this.l10n});

  final OrderUiModel order;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.order_number}: ${order.id}',
                style: getSemiBoldStyle(
                  fontSize: FontSize.size15,
                  fontFamily: FontConstant.cairo,
                  color: colors.onSurface,
                ),
              ),
              Text(
                '${l10n.my_orders_order_date}: ${formatOrderDate(order.createdAt)}',
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        OrderStatusBadge(status: order.status),
      ],
    );
  }
}

class OrderCardActionButton extends StatelessWidget {
  const OrderCardActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isPrimary = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextButton(
      onPressed: onPressed ?? () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: 10,
        ),
        backgroundColor:
            backgroundColor ??
            (isPrimary
                ? AppColors.primary.withValues(alpha: .10)
                : colors.surfaceContainerHighest.withValues(alpha: .45)),
        foregroundColor:
            foregroundColor ??
            (isPrimary ? AppColors.primary : colors.onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.buttonSmallRadius),
        ),
      ),
      child: Text(label, style: getMediumStyle(fontFamily: FontConstant.cairo)),
    );
  }
}
