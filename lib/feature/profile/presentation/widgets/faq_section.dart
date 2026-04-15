import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/faq_item.dart';

/// FAQ section widget
class FAQSection extends StatelessWidget {
  const FAQSection({super.key, required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final faqItems = [
      (
        question: l10n.faq_track_order_question,
        answer: l10n.faq_track_order_answer,
      ),
      (
        question: l10n.faq_payment_methods_question,
        answer: l10n.faq_payment_methods_answer,
      ),
      (
        question: l10n.faq_return_product_question,
        answer: l10n.faq_return_product_answer,
      ),
      (
        question: l10n.faq_contact_support_question,
        answer: l10n.faq_contact_support_answer,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.faq,
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.md),
          for (var i = 0; i < faqItems.length; i++) ...[
            FAQItem(question: faqItems[i].question, answer: faqItems[i].answer),
            if (i != faqItems.length - 1) const SizedBox(height: Spacing.sm),
          ],
        ],
      ),
    );
  }
}
