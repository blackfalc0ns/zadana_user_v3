import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String? orderId;
  const PaymentSuccessScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.screenH),
          child: Column(
            children: [
              const Spacer(),
              Lottie.asset(
                'assets/lottie_animation/success_payment.json',
                width: 190,
                height: 190,
                repeat: false,
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                l10n.payment_successful,
                style: getBoldStyle(
                  fontSize: FontSize.size24,
                  fontFamily: FontConstant.cairo,
                  color: colors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              if (orderId != null) ...[
                const SizedBox(height: Spacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.lg,
                    vertical: Spacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Spacing.md),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        color: colors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: Spacing.sm),
                      Text(
                        '${l10n.order_number}: ',
                        style: getMediumStyle(
                          fontSize: FontSize.size13,
                          fontFamily: FontConstant.cairo,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        orderId!,
                        style: getBoldStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              AppButton(
                text: l10n.track_order,
                icon: Icons.location_on_outlined,
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.trackOrder),
                color: colors.primary,
                textColor: colors.onPrimary,
                height: Spacing.buttonHeight,
              ),
              const SizedBox(height: Spacing.md),
              AppButton(
                text: l10n.back_to_home,
                icon: Icons.home_outlined,
                onPressed: () {
                  var foundMainShell = false;
                  Navigator.of(context).popUntil((route) {
                    final isMainShell =
                        route.settings.name == AppRoutes.mainShell;
                    if (isMainShell) foundMainShell = true;
                    return isMainShell || route.isFirst;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (foundMainShell && mainShellKey.currentState != null) {
                      mainShellKey.currentState?.jumpToTab(0);
                      return;
                    }
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const MainShell(initialIndex: 0),
                      ),
                      (route) => false,
                    );
                  });
                },
                color: colors.surfaceContainerHighest,
                textColor: colors.onSurface,
                height: Spacing.buttonHeight,
              ),
              const SizedBox(height: Spacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
