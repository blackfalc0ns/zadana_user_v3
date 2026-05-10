import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';

class PaymentFailedScreen extends StatelessWidget {
  const PaymentFailedScreen({super.key, this.orderId, this.message});

  final String? orderId;
  final String? message;

  void _navigateBackToHome(BuildContext context) {
    var foundMainShell = false;
    Navigator.of(context).popUntil((route) {
      final isMainShell =
          route.settings.name == AppRoutes.mainShell ||
          route.settings.name == AppRoutes.home;
      if (isMainShell) foundMainShell = true;
      return isMainShell || route.isFirst;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      if (foundMainShell && mainShellKey.currentState != null) {
        mainShellKey.currentState?.jumpToTab(0);
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final resolvedTitle = l10n.payment_confirmation_failed;
    final resolvedMessage = message?.trim().isNotEmpty == true
        ? message!.trim()
        : l10n.payment_confirmation_failed_message;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _navigateBackToHome(context);
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    Assets.errorPayment,
                    width: 190,
                    height: 190,
                    repeat: true,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    resolvedTitle,
                    style: getBoldStyle(
                      fontSize: FontSize.size24,
                      fontFamily: FontConstant.cairo,
                      color: colors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    resolvedMessage,
                    style: getRegularStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: colors.onSurface.withValues(alpha: 0.68),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  AppButton(
                    text: l10n.track_order,
                    icon: Icons.location_on_outlined,
                    onPressed: orderId == null || orderId!.isEmpty
                        ? null
                        : () => Navigator.pushNamed(
                            context,
                            AppRoutes.trackOrder,
                            arguments: orderId,
                          ),
                    color: colors.error,
                    textColor: colors.onError,
                    height: Spacing.buttonHeight,
                    borderRadius: 18,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.base,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton.outlined(
                    text: l10n.back_to_home,
                    icon: Icons.home_rounded,
                    onPressed: () => _navigateBackToHome(context),
                    color: colors.primary,
                    textColor: colors.primary,
                    height: Spacing.buttonHeight,
                    borderRadius: 18,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.base,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
