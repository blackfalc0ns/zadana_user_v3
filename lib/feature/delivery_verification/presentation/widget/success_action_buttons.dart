import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/widget/delivery_rating_dialog.dart'
    as delivery_dialog;

class SuccessActionButtons extends StatelessWidget {
  const SuccessActionButtons({
    super.key,
    this.courierName,
    this.courierImage,
    this.orderId,
  });

  final String? courierName;
  final String? courierImage;
  final String? orderId;

  void _onViewOrderDetails(BuildContext context) {
    HapticFeedback.lightImpact();

    delivery_dialog.showDeliveryRatingDialog(
      context,
      courierName: courierName ?? '',
      courierImage:
          'https://tse4.mm.bing.net/th/id/OIP.3L8yQPQsRHKjSg1FtHzVMQHaE8?w=508&h=339&rs=1&pid=ImgDetMain&o=7&rm=3',
      onSubmit: (rating, comment) {
        context.pushNamed(AppRoutes.orders);
      },
    );
  }

  void _onContinue(BuildContext context) {
    context.pushReplacementNamed(AppRoutes.mainShell);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AppButton(
            text: locale.delegate_values,
            onPressed: () => _onViewOrderDetails(context),
            isLoading: false,
            color: AppColors.primary,
            textColor: AppColors.white,
            height: 56,
            borderRadius: 16,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            text: locale.continue_shopping,
            onPressed: () => _onContinue(context),
            isLoading: false,
            color: AppColors.surface,
            textColor: AppColors.primary,
            height: 56,
            borderRadius: 16,
          ),
        ),
      ],
    );
  }
}
