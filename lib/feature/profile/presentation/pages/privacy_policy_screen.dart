import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/terms_conditions_screen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) => LegalScreen(
    title: AppLocalizations.of(context)!.privacy_policy,
    documentType: 'CustomerPrivacy',
  );
}
