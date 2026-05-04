import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/language_flag_avatar.dart';

/// Language option tile for bottom sheet
class LanguageOptionTile extends StatelessWidget {
  const LanguageOptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.languageCode,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String languageCode;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.xs,
      ),
      leading: Container(
        padding: const EdgeInsets.all(Spacing.xs),
        decoration: BoxDecoration(
          color: isSelected ? color.primaryContainer : color.surface,
          borderRadius: BorderRadius.circular(Spacing.xs),
        ),
        child: LanguageFlagAvatar(
          languageCode: languageCode,
          size: 28,
          borderRadius: 6,
        ),
      ),
      title: Text(
        title,
        style: getBoldStyle(
          fontSize: FontSize.size16,
          fontFamily: FontConstant.cairo,
          color: isSelected ? color.primary : color.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: getMediumStyle(
          fontSize: FontSize.size13,
          fontFamily: FontConstant.cairo,
          color: color.onSurfaceVariant,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: color.primary, size: 20)
          : null,
    );
  }
}

/// Shows language selection bottom sheet
void showLanguageBottomSheet({
  required BuildContext context,
  required String selectedLanguage,
  required Function(String) onLanguageSelected,
}) {
  final color = context.colorScheme;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Spacing.sm),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: color.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: Spacing.base),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
            child: Text(
              'اختر اللغة',
              style: getBoldStyle(
                fontSize: FontSize.size18,
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
              ),
            ),
          ),
          const SizedBox(height: Spacing.base),
          LanguageOptionTile(
            title: 'العربية',
            subtitle: 'Arabic',
            languageCode: 'ar',
            isSelected: selectedLanguage == 'ar',
            onTap: () {
              Navigator.pop(ctx);
              onLanguageSelected('ar');
            },
          ),
          const Divider(height: 1),
          LanguageOptionTile(
            title: 'English',
            subtitle: 'الإنجليزية',
            languageCode: 'en',
            isSelected: selectedLanguage == 'en',
            onTap: () {
              Navigator.pop(ctx);
              onLanguageSelected('en');
            },
          ),
          const SizedBox(height: Spacing.base),
        ],
      ),
    ),
  );
}
