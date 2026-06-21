import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';

class SuccessActionButtons extends StatelessWidget {
  const SuccessActionButtons({
    super.key,
    this.courierName,
    this.courierImage,
  });

  final String? courierName;
  final String? courierImage;

  void _onContinue(BuildContext context) {
    context.pushReplacementNamed(AppRoutes.mainShell);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton(
            text: locale.continue_shopping,
            onPressed: () => _onContinue(context),
            color: AppColors.primary,
            textColor: AppColors.white,
            height: 58,
            borderRadius: 18,
          ),
        ],
      ),
    );
  }
}
