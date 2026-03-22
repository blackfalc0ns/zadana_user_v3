import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';

class OrderSuccessDialog extends StatelessWidget {
  final String orderNumber;
  final String estimatedTime;
  final VoidCallback onTrackOrder;
  final VoidCallback onBackToHome;

  const OrderSuccessDialog({
    super.key,
    required this.orderNumber,
    required this.estimatedTime,
    required this.onTrackOrder,
    required this.onBackToHome,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.cardRadius + 8),
      ),
      contentPadding: const EdgeInsets.all(Spacing.xl),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSuccessAnimation(colors),
          const SizedBox(height: Spacing.xl),
          Text(
            l10n.order_success,
            style: getBoldStyle(
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
              color: colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.md),
          _buildOrderInfo(l10n, colors),
          const SizedBox(height: Spacing.xl),
          AppButton.filled(
            text: l10n.track_order,
            onPressed: onTrackOrder,
          ),
          const SizedBox(height: Spacing.md),
          AppButton.outlined(
            text: l10n.back_to_home,
            onPressed: onBackToHome,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessAnimation(ColorScheme colors) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.secondary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colors.secondary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.check_rounded,
              color: colors.onSecondary,
              size: 40,
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderInfo(AppLocalizations l10n, ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Spacing.sm),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Text(
            '${l10n.order_number}: $orderNumber',
            style: getBoldStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            '${l10n.estimated_delivery}: $estimatedTime',
            style: getRegularStyle(
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
