import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/faq_item.dart';

/// FAQ section widget
class FAQSection extends StatelessWidget {
  final AppLocalizations l10n;

  const FAQSection({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

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
          const FAQItem(
            question: 'كيف يمكنني تتبع طلبي؟',
            answer: 'يمكنك تتبع طلبك من خلال قسم "طلباتي" في التطبيق',
          ),
          const SizedBox(height: Spacing.sm),
          const FAQItem(
            question: 'ما هي طرق الدفع المتاحة؟',
            answer: 'نقبل الدفع بالبطاقة الائتمانية، مدى، وأبل باي',
          ),
          const SizedBox(height: Spacing.sm),
          const FAQItem(
            question: 'كيف يمكنني إرجاع منتج؟',
            answer: 'يمكنك طلب الإرجاع من خلال صفحة تفاصيل الطلب خلال 14 يوم',
          ),
        ],
      ),
    );
  }
}
