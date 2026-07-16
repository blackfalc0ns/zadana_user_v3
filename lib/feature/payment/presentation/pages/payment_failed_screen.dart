import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/pages/order_details_page.dart';

class PaymentFailedScreen extends StatelessWidget {
  const PaymentFailedScreen({super.key, this.orderId, this.message});

  final String? orderId;
  final String? message;

  void _navigateToRetryPayment(BuildContext context) {
    if (orderId == null || orderId!.isEmpty) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<OrderDetailsViewModel>()..load(orderId!),
          child: OrderDetailsPage(orderId: orderId),
        ),
      ),
    );
  }

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
    final resolvedMessage = (message != null && message!.isNotEmpty)
        ? message!
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
                  SizedBox(
                    height: 250,
                    child: Transform.scale(
                      // The Lottie asset has generous transparent padding.
                      // Scaling it here makes the failed-payment mark readable
                      // without adding unnecessary empty space to the screen.
                      scale: 1.65,
                      child: Lottie.asset(
                        Assets.errorPayment,
                        width: 250,
                        height: 250,
                        repeat: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    resolvedTitle,
                    style: getSemiBoldStyle(
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
                  const SizedBox(height: 32),
                  AppButton(
                    text: l10n.my_orders_retry_payment,
                    icon: Icons.refresh_rounded,
                    onPressed: orderId == null || orderId!.isEmpty
                        ? null
                        : () => _navigateToRetryPayment(context),
                    color: colors.primary,
                    textColor: colors.onPrimary,
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
