import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key, this.orderId});
  final String? orderId;

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
  }

  void _startAnimations() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _confettiController.play();
    });

    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();
  }

  void _navigateBackToHome() {
    var foundMainShell = false;
    Navigator.of(context).popUntil((route) {
      final isMainShell =
          route.settings.name == AppRoutes.mainShell ||
          route.settings.name == AppRoutes.home;
      if (isMainShell) foundMainShell = true;
      return isMainShell || route.isFirst;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

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
  void dispose() {
    _confettiController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        _navigateBackToHome();
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        body: Stack(
          children: [
            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [Colors.green, Colors.blue],
              ),
            ),

            // Main content
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Success animation
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Lottie.asset(
                            'assets/lottie_animation/success_payment.json',
                            width: 180,
                            height: 180,
                            repeat: false,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Title
                        Text(
                          l10n.payment_successful,
                          style: getBoldStyle(
                            fontSize: FontSize.size24,
                            fontFamily: FontConstant.cairo,
                            color: colors.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          'تمت عملية الدفع بنجاح',
                          style: getRegularStyle(
                            fontSize: FontSize.size14,
                            fontFamily: FontConstant.cairo,
                            color: colors.onSurface.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 48),

                        // Track order button
                        AppButton(
                          text: l10n.track_order,
                          icon: Icons.location_on_outlined,
                          onPressed: widget.orderId == null
                              ? null
                              : () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.trackOrder,
                                  arguments: widget.orderId,
                                ),
                          color: colors.primary,
                          textColor: colors.onPrimary,
                          height: Spacing.buttonHeight,
                        ),

                        const SizedBox(height: 12),

                        // Delivery OTP button
                        AppButton(
                          text: 'Delivery OTP',
                          icon: Icons.qr_code_rounded,
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.deliveryOtp,
                          ),
                          color: colors.surface,
                          textColor: colors.onSurface,
                          height: Spacing.buttonHeight,
                        ),

                        const SizedBox(height: 12),

                        // Back to home button
                        AppButton(
                          text: l10n.back_to_home,
                          icon: Icons.home_outlined,
                          onPressed: _navigateBackToHome,
                          color: colors.surface,
                          textColor: colors.onSurface,
                          height: Spacing.buttonHeight,
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
