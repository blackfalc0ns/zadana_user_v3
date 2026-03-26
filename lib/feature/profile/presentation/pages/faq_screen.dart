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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final questions = isArabic
        ? const [
            (
              'كيف يمكنني تتبع طلبي؟',
              'يمكنك تتبع طلبك من خلال صفحة طلباتي، ثم اختيار الطلب الذي تريد معرفة حالته.'
            ),
            (
              'ما هي طرق الدفع المتاحة؟',
              'نقبل الدفع ببطاقات الدفع المختلفة، والمحافظ الإلكترونية، والدفع عند الاستلام حسب المتاح.'
            ),
            (
              'كيف يمكنني إرجاع منتج؟',
              'يمكنك طلب الإرجاع من صفحة تفاصيل الطلب خلال الفترة المسموح بها وفق سياسة الإرجاع.'
            ),
            (
              'كيف أتواصل مع الدعم؟',
              'يمكنك التواصل معنا من خلال صفحة المساعدة والدعم أو عبر وسائل التواصل المتاحة داخل التطبيق.'
            ),
          ]
        : const [
            (
              'How can I track my order?',
              'You can track your order from the My Orders page, then open the order you want to follow.'
            ),
            (
              'What payment methods are available?',
              'We support common payment cards, e-wallets, and cash on delivery when available.'
            ),
            (
              'How can I return a product?',
              'You can request a return from the order details page within the allowed return period.'
            ),
            (
              'How do I contact support?',
              'You can contact us through the Help & Support page or the communication methods available in the app.'
            ),
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
          return FAQItem(
            question: item.$1,
            answer: item.$2,
          );
        },
      ),
    );
  }
}
