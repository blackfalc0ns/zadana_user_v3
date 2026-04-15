import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/contact_section.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/faq_section.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/help_support_header.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(title: l10n.help_support),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HelpSupportHeader(),
            const SizedBox(height: 24),
            ContactSection(l10n: l10n),
            const SizedBox(height: 32),
            FAQSection(l10n: l10n),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
