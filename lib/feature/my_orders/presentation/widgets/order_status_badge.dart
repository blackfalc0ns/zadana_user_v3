import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = orderStatusColors(Theme.of(context).colorScheme, status);

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: colors.$1,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          orderStatusLabel(l10n, status),
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            color: colors.$2,
          ),
        ),
      ),
    );
  }
}

(Color, Color) orderStatusColors(ColorScheme scheme, OrderStatus status) {
  switch (status) {
    case OrderStatus.delivered:
      return (const Color(0xFFE7F8EE), const Color(0xFF157347));
    case OrderStatus.cancelled:
    case OrderStatus.vendorRejected:
    case OrderStatus.deliveryFailed:
      return (const Color(0xFFFDECEC), const Color(0xFFC62828));
    case OrderStatus.processing:
    case OrderStatus.shipped:
    case OrderStatus.pending:
    case OrderStatus.returning:
      return (AppColors.secondary.withValues(alpha: .14), AppColors.secondary);
    case OrderStatus.unknown:
      return (
        scheme.surfaceContainerHighest.withValues(alpha: .5),
        scheme.onSurfaceVariant,
      );
  }
}

String orderStatusLabel(AppLocalizations l10n, OrderStatus status) {
  switch (status) {
    case OrderStatus.delivered:
      return l10n.order_delivered;
    case OrderStatus.cancelled:
      return l10n.order_cancelled;
    case OrderStatus.vendorRejected:
      return _localizedTerminalLabel(
        l10n,
        arabic: 'مرفوض',
        english: 'Rejected',
      );
    case OrderStatus.deliveryFailed:
      return _localizedTerminalLabel(
        l10n,
        arabic: 'فشل التوصيل',
        english: 'Delivery Failed',
      );
    case OrderStatus.returning:
      return l10n.order_returning;
    case OrderStatus.pending:
    case OrderStatus.processing:
    case OrderStatus.shipped:
    case OrderStatus.unknown:
      return l10n.order_pending;
  }
}

String _localizedTerminalLabel(
  AppLocalizations l10n, {
  required String arabic,
  required String english,
}) {
  final languageCode = l10n.localeName.toLowerCase();
  if (languageCode.startsWith('ar')) {
    return arabic;
  }
  return english;
}
