import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = context.colorScheme;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final sections = isArabic
        ? const [
            (
              'جمع البيانات',
              'نقوم بجمع البيانات الأساسية اللازمة لإنشاء الحساب، وإتمام الطلبات، وتحسين تجربة الاستخدام داخل التطبيق.'
            ),
            (
              'استخدام البيانات',
              'تستخدم البيانات لتجهيز الطلبات، وإرسال الإشعارات المهمة، وتقديم دعم أفضل للمستخدمين.'
            ),
            (
              'مشاركة البيانات',
              'لا تتم مشاركة بياناتك إلا عند الحاجة لتقديم الخدمة مثل شركات الشحن أو مزودي الدفع المعتمدين.'
            ),
            (
              'حماية الخصوصية',
              'نلتزم باتخاذ إجراءات مناسبة لحماية بياناتك ومنع الوصول غير المصرح به إليها.'
            ),
          ]
        : const [
            (
              'Data Collection',
              'We collect basic information required to create accounts, complete orders, and improve the in-app experience.'
            ),
            (
              'Data Usage',
              'Your data is used to process orders, send important notifications, and provide better support.'
            ),
            (
              'Data Sharing',
              'Your data is only shared when necessary to provide the service, such as with shipping or payment providers.'
            ),
            (
              'Privacy Protection',
              'We take reasonable steps to protect your data and prevent unauthorized access.'
            ),
          ];

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(title: l10n.privacy_policy),
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
