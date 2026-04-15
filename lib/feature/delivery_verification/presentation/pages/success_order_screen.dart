import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/widget/courier_info_card.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/widget/order_info_card.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/widget/success_action_buttons.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/widget/success_animation_widget.dart';

class SuccessOrderScreen extends StatefulWidget {
  const SuccessOrderScreen({
    super.key,
    this.orderId,
    this.courierName,
    this.courierImage,
  });

  final String? orderId;
  final String? courierName;
  final String? courierImage;

  @override
  State<SuccessOrderScreen> createState() => _SuccessOrderScreenState();
}

class _SuccessOrderScreenState extends State<SuccessOrderScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startConfetti();
  }

  void _initAnimations() {
    // Fade animation for content
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Scale animation for checkmark
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Slide animation for content
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations in sequence
    _startAnimations();
  }

  void _startAnimations() async {
    // Start with confetti
    await Future.delayed(const Duration(milliseconds: 300));

    // Then fade in content
    _fadeController.forward();

    // Scale up the checkmark
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();

    // Slide up the content
    await Future.delayed(const Duration(milliseconds: 100));
    _slideController.forward();

    // Show content
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => _showContent = true);
    }
  }

  void _startConfetti() {
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // Start confetti after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 40),
                        // Success GIF with Confetti
                        SuccessAnimationWidget(
                          confettiController: _confettiController,
                        ),

                        const SizedBox(height: 32),

                        // Title
                        Text(
                          locale.order_success_title,
                          style: getBoldStyle(
                            fontSize: FontSize.size24,
                            fontFamily: FontConstant.cairo,
                            color: color.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          locale.order_success_subtitle,
                          style: getRegularStyle(
                            fontSize: FontSize.size14,
                            fontFamily: FontConstant.cairo,
                            color: color.onSurface.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        if (widget.orderId != null) ...[
                          const SizedBox(height: 16),
                          OrderInfoCard(orderId: widget.orderId!),
                        ],

                        if (widget.courierName != null) ...[
                          const SizedBox(height: 16),
                          CourierInfoCard(
                            courierName: widget.courierName!,
                            courierImage: widget.courierImage,
                          ),
                        ],

                        const SizedBox(height: 40),

                        // Action buttons
                        if (_showContent)
                          SuccessActionButtons(
                            orderId: widget.orderId,
                            courierName: widget.courierName,
                            courierImage: widget.courierImage,
                          ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
