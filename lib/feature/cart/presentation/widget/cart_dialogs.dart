import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

void showDeleteItemDialog({
  required BuildContext context,
  required String itemName,
  required VoidCallback onConfirm,
}) {
  final locale = context.localization;

  showDialog(
    context: context,
    builder: (_) => _CartActionDialog(
      icon: Icons.delete_outline_rounded,
      title: locale.delete_item,
      message: '${locale.delete_item_confirmation} "$itemName" من السلة؟',
      confirmLabel: locale.delete,
      onConfirm: onConfirm,
    ),
  );
}

void showClearCartDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  final locale = context.localization;

  showDialog(
    context: context,
    builder: (_) => _CartActionDialog(
      icon: Icons.remove_shopping_cart_outlined,
      title: locale.clear_cart,
      message: locale.clear_cart_confirmation,
      confirmLabel: locale.clear_all,
      onConfirm: onConfirm,
    ),
  );
}

Future<bool?> showCheckoutRegistrationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (_) => const _CheckoutRegistrationDialog(),
  );
}

void showDeliveryUnavailableDialog({
  required BuildContext context,
  required String message,
}) {
  showDialog(
    context: context,
    builder: (_) => _DeliveryUnavailableDialog(message: message),
  );
}

void showUnavailableProductsCheckoutDialog({
  required BuildContext context,
  required int unavailableCount,
}) {
  showDialog<void>(
    context: context,
    builder: (_) =>
        _UnavailableProductsCheckoutDialog(unavailableCount: unavailableCount),
  );
}

class _UnavailableProductsCheckoutDialog extends StatelessWidget {
  const _UnavailableProductsCheckoutDialog({required this.unavailableCount});

  final int unavailableCount;

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
              color: AppColors.warning.withValues(alpha: 0.24),
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.14),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warning.withValues(alpha: 0.12),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.25),
                  ),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.warning,
                  size: 36,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                locale.cart_unavailable_products_title,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size20,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                locale.cart_unavailable_checkout_dialog_message(
                  unavailableCount,
                ),
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: color.onSurfaceVariant,
                ).copyWith(height: 1.65),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: color.primary,
                    foregroundColor: color.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.edit_note_rounded, size: 21),
                  label: Text(
                    locale.cart_unavailable_checkout_dialog_action,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: color.onPrimary,
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

class _CheckoutRegistrationDialog extends StatelessWidget {
  const _CheckoutRegistrationDialog();

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: color.outlineVariant.withValues(alpha: 0.45),
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.16),
                blurRadius: 36,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryLight.withValues(alpha: 0.20),
                      AppColors.primary.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 38,
                  color: color.primary,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                locale.checkout_login_title,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size24,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                locale.checkout_login_message,
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size15,
                  color: color.onSurfaceVariant,
                ).copyWith(height: 1.7),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: color.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: color.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        locale.checkout_login_helper,
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size13,
                          color: color.onSurface,
                        ).copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: color.primary,
                    foregroundColor: color.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.login_rounded, size: 20),
                  label: Text(
                    locale.checkout_login_action,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size15,
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
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    locale.no,
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

class _CartActionDialog extends StatelessWidget {
  const _CartActionDialog({
    required this.icon,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
  });

  final IconData icon;
  final String title;
  final String message;
  final String confirmLabel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: color.outlineVariant.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.error.withValues(alpha: 0.16),
                      AppColors.warning.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.12),
                  ),
                ),
                child: Icon(icon, size: 36, color: color.error),
              ),
              const SizedBox(height: 18),
              Text(
                title,
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
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                    color: color.onSurfaceVariant,
                  ).copyWith(height: 1.6),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: color.error,
                          foregroundColor: color.onError,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          confirmLabel,
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: color.onError,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: color.onSurfaceVariant,
                          side: BorderSide(
                            color: color.outlineVariant,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          locale.no,
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeliveryUnavailableDialog extends StatelessWidget {
  const _DeliveryUnavailableDialog({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Directionality(
      textDirection: Directionality.of(context),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF3E0),
                  border: Border.all(
                    color: const Color(0xFFFFE0B2),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.location_off_rounded,
                  size: 34,
                  color: Color(0xFFE65100),
                ),
              ),
              const SizedBox(height: 20),
              // Title
              Text(
                locale.delivery_unavailable_title,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 14),
              // Message from backend
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFFFE082),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: Color(0xFFF57C00),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          color: const Color(0xFF4E342E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Hint text
              Text(
                locale.delivery_unavailable_hint,
                textAlign: TextAlign.center,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size13,
                  color: AppColors.error,
                ).copyWith(height: 1.4),
              ),
              const SizedBox(height: 20),
              // Change address button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.customerAddresses);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: color.primary,
                    foregroundColor: color.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    locale.delivery_unavailable_change_address,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: color.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Dismiss button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color.primary,
                    elevation: 0,
                    side: BorderSide(color: color.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    locale.delivery_unavailable_dismiss,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: color.primary,
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
