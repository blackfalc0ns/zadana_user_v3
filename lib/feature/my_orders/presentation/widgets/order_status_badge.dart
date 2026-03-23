import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = _statusColors(Theme.of(context).colorScheme, status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _statusLabel(l10n, status),
        style: getMediumStyle(
          fontSize: FontSize.size12,
          fontFamily: FontConstant.cairo,
          color: colors.$2,
        ),
      ),
    );
  }

  (Color, Color) _statusColors(ColorScheme scheme, OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return (const Color(0xFFE7F8EE), const Color(0xFF157347));
      case OrderStatus.processing:
        return (AppColors.secondary.withOpacity(.14), AppColors.secondary);
      case OrderStatus.cancelled:
        return (const Color(0xFFFDECEC), const Color(0xFFC62828));
      case OrderStatus.shipped:
        return (AppColors.secondary.withOpacity(.14), AppColors.secondary);
      case OrderStatus.pending:
        return (AppColors.secondary.withOpacity(.14), AppColors.secondary);
    }
  }

  String _statusLabel(AppLocalizations l10n, OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return l10n.order_pending;
      case OrderStatus.processing:
        return l10n.order_pending;
      case OrderStatus.shipped:
        return l10n.order_pending;
      case OrderStatus.delivered:
        return l10n.order_delivered;
      case OrderStatus.cancelled:
        return l10n.order_cancelled;
    }
  }
}
