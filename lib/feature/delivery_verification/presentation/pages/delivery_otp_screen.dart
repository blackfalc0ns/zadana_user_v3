import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/manager/delivery_otp_state.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/manager/delivery_otp_view_model.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/widget/delivery_rating_dialog.dart'
    as delivery_dialog;

class DeliveryOtpScreen extends StatefulWidget {
  const DeliveryOtpScreen({
    super.key,
    this.orderId,
    this.phoneNumber,
    this.courierName,
  });

  final String? orderId;
  final String? phoneNumber;
  final String? courierName;

  @override
  State<DeliveryOtpScreen> createState() => _DeliveryOtpScreenState();
}

class _DeliveryOtpScreenState extends State<DeliveryOtpScreen> {
  Timer? _navigateTimer;

  @override
  void initState() {
    super.initState();
    // Navigate to success page after 5 seconds
    _navigateTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.successOrder,
          arguments: {'orderId': widget.orderId, 'courierName': 'Ayşe Demirci'},
        );
      }
    });
  }

  @override
  void dispose() {
    _navigateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(title: locale.delivery_otp_title),
      body: BlocProvider(
        create: (_) => getIt<DeliveryOtpViewModel>(),
        child: BlocListener<DeliveryOtpViewModel, DeliveryOtpState>(
          listener: _handleStateChanges,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              children: [
                const SizedBox(height: Spacing.xl),

                // Delivery Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_shipping_outlined,
                    size: 50,
                    color: color.primary,
                  ),
                ),
                const SizedBox(height: Spacing.lg),

                // Title
                Text(
                  locale.delivery_code_title,
                  style: getBoldStyle(
                    fontSize: FontSize.size22,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.sm),

                // Phone Number Info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: color.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        locale.delivery_code_share_instruction,
                        style: getRegularStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: color.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        '0345667892',
                        style: getBoldStyle(
                          fontSize: FontSize.size18,
                          fontFamily: FontConstant.cairo,
                          color: color.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.xl),

                // OTP Code Display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: Spacing.xl),
                  decoration: BoxDecoration(
                    color: color.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: color.outline.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.shadow.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        locale.delivery_code_share_label,
                        style: getMediumStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: color.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: Spacing.sm),
                      Text(
                        '1234',
                        style: getBoldStyle(
                          fontSize: 48,
                          fontFamily: FontConstant.cairo,
                          color: color.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.xl),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: locale.delivery_code_shared_button,
                    onPressed: () {
                      // Navigate to success page immediately
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.successOrder,
                        arguments: {
                          'orderId': widget.orderId,
                          'courierName': widget.courierName ?? 'محمد أمين',
                        },
                      );
                    },
                    color: color.primary,
                    textColor: color.onPrimary,
                    height: 56,
                  ),
                ),
                const SizedBox(height: Spacing.md),

                // Resend Option
                TextButton(
                  onPressed: () {},
                  child: Text(
                    locale.delivery_code_generate_new,
                    style: getMediumStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: color.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, DeliveryOtpState state) {
    // Show rating dialog on success
    if (state.isSuccess || state.showSuccessDialog) {
      Future.microtask(() {
        delivery_dialog.showDeliveryRatingDialog(
          context,
          courierName: widget.courierName ?? 'Ayşe Demirci',
          courierImage:
              'https://tse4.mm.bing.net/th/id/OIP.3L8yQPQsRHKjSg1FtHzVMQHaE8?w=508&h=339&rs=1&pid=ImgDetMain&o=7&rm=3',
          onSubmit: (rating, comment) {
            // Handle rating submission (can be sent to API later)
            print('Rating: $rating, Comment: $comment');
            // Navigate to success order page after rating
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.successOrder,
              arguments: {
                'orderId': widget.orderId,
                'courierName': widget.courierName ?? 'Ayşe Demirci',
              },
            );
          },
        );
      });
    }

    if (state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
