import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

Future<bool> showCheckoutPhoneRequiredDialog({
  required BuildContext context,
  required String message,
}) async {
  return await showDialog<bool>(
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.58),
        builder: (_) => _CheckoutPhoneRequiredDialog(message: message),
      ) ??
      false;
}

class _CheckoutPhoneRequiredDialog extends StatelessWidget {
  const _CheckoutPhoneRequiredDialog({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Directionality(
      textDirection: Directionality.of(context),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 36,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryLight.withValues(alpha: 0.20),
                      AppColors.secondary.withValues(alpha: 0.10),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.18),
                  ),
                ),
                child: Icon(
                  Icons.phone_iphone_rounded,
                  color: color.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                locale.phone_number_is_required,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size20,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: color.outlineVariant.withValues(alpha: 0.55),
                  ),
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                    color: color.onSurface,
                  ).copyWith(height: 1.65),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: color.primary,
                    foregroundColor: color.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.edit_rounded, size: 19),
                  label: Text(
                    locale.checkout_add_phone_action,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: color.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color.onSurfaceVariant,
                    side: BorderSide(color: color.outlineVariant, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    locale.cancel,
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
