import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final assetPath = isArabic
        ? Assets.customerTermsAr
        : Assets.customerTermsEn;
    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: isArabic ? 'الشروط والأحكام' : 'Terms and Conditions',
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                isArabic
                    ? 'تعذر تحميل الشروط والأحكام.'
                    : 'Unable to load the terms and conditions.',
              ),
            );
          }
          return _TermsDocument(
            markdown: snapshot.data ?? '',
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          );
        },
      ),
    );
  }
}

class _TermsDocument extends StatelessWidget {
  const _TermsDocument({required this.markdown, required this.textDirection});
  final String markdown;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final lines = markdown.split('\n').where((line) {
      // Notes for the mobile team are intentionally excluded from the
      // customer-facing legal document.
      return !line.trimLeft().startsWith('>');
    }).toList();

    return Directionality(
      textDirection: textDirection,
      child: ListView.builder(
        padding: const EdgeInsets.all(Spacing.lg),
        itemCount: lines.length,
        itemBuilder: (context, index) {
          final line = lines[index].trim();
          if (line.isEmpty || line == '---') {
            return const SizedBox(height: Spacing.sm);
          }
          final isTitle = line.startsWith('# ');
          final isHeading = line.startsWith('## ');
          final text = line
              .replaceFirst(RegExp(r'^#{1,2}\\s*'), '')
              .replaceAll('**', '')
              .replaceAll('`', '');
          return Padding(
            padding: const EdgeInsets.only(bottom: Spacing.sm),
            child: SelectableText(
              text,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: isTitle || isHeading
                    ? color.onSurface
                    : color.onSurfaceVariant,
                fontSize: isTitle ? 22 : (isHeading ? 18 : 14),
                fontWeight: isTitle || isHeading
                    ? FontWeight.w700
                    : FontWeight.w400,
                height: 1.7,
              ),
            ),
          );
        },
      ),
    );
  }
}
