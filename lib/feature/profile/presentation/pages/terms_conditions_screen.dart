import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = context.colorScheme;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final sections = isArabic
        ? const [
            (
              'الاستخدام المقبول',
              'يجب استخدام التطبيق بطريقة قانونية وعدم إساءة استخدام الخدمات أو محاولة الإضرار بالمنصة أو بالمستخدمين.'
            ),
            (
              'الطلبات والدفع',
              'تأكيد الطلب يعتمد على توفر المنتجات ونجاح عملية الدفع أو قبول الطلب حسب طريقة الدفع المختارة.'
            ),
            (
              'الأسعار والتوافر',
              'قد تختلف الأسعار والتوافر حسب المتجر أو المنطقة، ويحق للتطبيق تحديثها في أي وقت.'
            ),
            (
              'الإلغاء والاسترجاع',
              'تخضع عمليات الإلغاء والاسترجاع لسياسات المتجر والحالات المسموح بها داخل التطبيق.'
            ),
          ]
        : const [
            (
              'Acceptable Use',
              'The app must be used lawfully and without abusing services or attempting to harm the platform or other users.'
            ),
            (
              'Orders and Payments',
              'Order confirmation depends on product availability and successful payment or merchant acceptance.'
            ),
            (
              'Pricing and Availability',
              'Prices and availability may vary by store or area and may be updated at any time.'
            ),
            (
              'Cancellation and Returns',
              'Cancellation and return requests are subject to store policy and the supported in-app cases.'
            ),
          ];

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(title: l10n.terms_conditions),
      body: ListView.separated(
        padding: const EdgeInsets.all(Spacing.lg),
        itemCount: sections.length,
        separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
        itemBuilder: (context, index) {
          final section = sections[index];
          return Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: color.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(Spacing.md),
              border: Border.all(
                color: color.outline.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.$1,
                  style: getBoldStyle(
                    fontSize: FontSize.size15,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  section.$2,
                  style: getRegularStyle(
                    fontSize: FontSize.size13,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurfaceVariant,
                  ).copyWith(height: 1.6),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
