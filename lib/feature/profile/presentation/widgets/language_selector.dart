import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

/// Language option tile for bottom sheet
class LanguageOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageOptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

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
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? color.primaryContainer : color.surface,
          borderRadius: BorderRadius.circular(Spacing.xs),
        ),
        child: FaIcon(
          FontAwesomeIcons.globe,
          color: isSelected ? color.primary : color.onSurfaceVariant,
          size: 20,
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
          ? FaIcon(
              FontAwesomeIcons.circleCheck,
              color: color.primary,
              size: 20,
            )
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
