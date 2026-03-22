import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/progress_indicator_widget.dart';

class PaymentProgressSection extends StatelessWidget {
  const PaymentProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ProgressIndicatorWidget(
      steps: [
        ProgressStep(
          title: l10n.nav_cart,
          isActive: true,
          isCompleted: true,
        ),
        ProgressStep(
          title: l10n.checkout,
          isActive: true,
          isCompleted: false,
        ),
        ProgressStep(
          title: l10n.confirm,
          isActive: false,
          isCompleted: false,
        ),
      ],
    );
  }
}
