import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/widget/delivery_rating_dialog.dart'
    as delivery_dialog;

/// ═══════════════════════════════════════════════════════════════
/// SUCCESS ORDER SCREEN
/// صفحة نجاح الطلب - Order Success Page
/// Shows success animation with confetti after delivery verification
/// ═══════════════════════════════════════════════════════════════

class SuccessOrderScreen extends StatefulWidget {
  const SuccessOrderScreen({
    super.key,
    this.orderId,
    this.courierName,
  });

  final String? orderId;
  final String? courierName;

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
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Scale animation for checkmark
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );

    // Slide animation for content
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
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

  void _onContinue(BuildContext context) {
    // Haptic feedback
    HapticFeedback.lightImpact();
    
    // Show delivery rating dialog first
    delivery_dialog.showDeliveryRatingDialog(
      context,
      courierName: widget.courierName ?? 'Ayşe Demirci',
      courierImage: 'https://tse4.mm.bing.net/th/id/OIP.3L8yQPQsRHKjSg1FtHzVMQHaE8?w=508&h=339&rs=1&pid=ImgDetMain&o=7&rm=3',
      onSubmit: (rating, comment) {
        // Navigate to main screen after rating
        context.pushReplacementNamed(AppRoutes.mainShell);
      },
    );
  }

  void _onViewOrderDetails(BuildContext context) {
    // Haptic feedback
    HapticFeedback.lightImpact();
    
    // Show delivery rating dialog first
    delivery_dialog.showDeliveryRatingDialog(
      context,
      courierName: widget.courierName ?? 'Ayşe Demirci',
      courierImage: 'https://tse4.mm.bing.net/th/id/OIP.3L8yQPQsRHKjSg1FtHzVMQHaE8?w=508&h=339&rs=1&pid=ImgDetMain&o=7&rm=3',
      onSubmit: (rating, comment) {
        // Navigate to orders page after rating
        context.pushNamed(AppRoutes.orders);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      // appBar: CustomAppBar(
      //   title: locale.order_success_title,
      //   showBack: false,
      // ),
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
                        // Success GIF
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.border.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Image.asset(
                              'assets/images/success_order_animation.gif',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.background,
                                  child: Icon(
                                    Icons.celebration,
                                    size: 80,
                                    color: AppColors.primary,
                                  ),
                                );
                              },
                            ),
                          ),
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

                          // Order ID
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: color.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: color.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  size: 18,
                                  color: color.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${locale.order_number}: ${widget.orderId}',
                                  style: getMediumStyle(
                                    fontSize: FontSize.size13,
                                    fontFamily: FontConstant.cairo,
                                    color: color.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        if (widget.courierName != null) ...[
                          const SizedBox(height: 16),

                          // Courier info
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.border.withValues(alpha: 0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary.withValues(alpha: 0.2),
                                        AppColors.primary.withValues(alpha: 0.05),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.delivery_dining,
                                    size: 28,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        locale.courier_name,
                                        style: getRegularStyle(
                                          fontSize: FontSize.size11,
                                          fontFamily: FontConstant.cairo,
                                          color: color.onSurface.withValues(alpha: 0.5),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.courierName!,
                                        style: getBoldStyle(
                                          fontSize: FontSize.size15,
                                          fontFamily: FontConstant.cairo,
                                          color: color.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 40),

                        // Action buttons
                        if (_showContent) ...[
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              text: locale.continue_shopping,
                              onPressed: () => _onContinue(context),
                              isLoading: false,
                              color: AppColors.primary,
                              textColor: AppColors.white,
                              height: 56,
                              borderRadius: 16,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // View order details button
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              text: locale.view_order_details,
                              onPressed: () => _onViewOrderDetails(context),
                              isLoading: false,
                              color: AppColors.surface,
                              textColor: AppColors.primary,
                              height: 56,
                              borderRadius: 16,
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),     
              // Confetti layer
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors:  [
                Color(0xFF4CAF50),
                Color(0xFF2196F3),
                Color(0xFFFFC107),
                Color(0xFFFF5722),
                Color(0xFF9C27B0),
              ],
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
