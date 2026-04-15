import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/faq_item.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = context.colorScheme;
    final questions = [
      (l10n.faq_track_order_question, l10n.faq_track_order_answer),
      (l10n.faq_payment_methods_question, l10n.faq_payment_methods_answer),
      (l10n.faq_return_product_question, l10n.faq_return_product_answer),
      (l10n.faq_contact_support_question, l10n.faq_contact_support_answer),
    ];

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(title: l10n.faq),
      body: ListView.separated(
        padding: const EdgeInsets.all(Spacing.lg),
        itemCount: questions.length,
        separatorBuilder: (_, _) => const SizedBox(height: Spacing.sm),
        itemBuilder: (context, index) {
          final item = questions[index];
          return FAQItem(question: item.$1, answer: item.$2);
        },
      ),
    );
  }
}
