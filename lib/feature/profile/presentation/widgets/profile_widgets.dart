import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

/// Profile card widget - displays user info and edit button
class ProfileCard extends StatelessWidget {
  final String userName;
  final String userPhone;
  final VoidCallback onTap;

  const ProfileCard({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(Spacing.sm),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(Spacing.sm),
            border: Border.all(
              color: color.outline,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: color.primaryContainer,
                    child: Text(
                      userName.isNotEmpty ? userName[0] : 'م',
                      style: getBoldStyle(
                        fontSize: FontSize.size20,
                        fontFamily: FontConstant.cairo,
                        color: color.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: color.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color.surface,
                          width: 1.5,
                        ),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.pen,
                        size: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: getBoldStyle(
                        fontSize: FontSize.size16,
                        fontFamily: FontConstant.cairo,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userPhone,
                      style: getMediumStyle(
                        fontSize: FontSize.size13,
                        fontFamily: FontConstant.cairo,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Menu tile widget - clickable row with icon and title
class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool showBorder;
  final bool showChevron;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    this.trailing,
    required this.onTap,
    this.showBorder = true,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: showBorder ? color.outline.withOpacity(0.3) : Colors.transparent,
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: 2,
        ),
        leading: FaIcon(
          icon,
          color: iconColor,
          size: 18,
        ),
        title: Text(
          title,
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: color.onSurface,
          ),
        ),
        trailing: trailing ??
            (showChevron
                ? FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    color: color.onSurfaceVariant,
                    size: 12,
                  )
                : null),
      ),
    );
  }
}

/// Logout button widget
class ProfileLogoutButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ProfileLogoutButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: color.errorContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(Spacing.sm),
            border: Border.all(
              color: color.errorContainer,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.rightFromBracket,
                color: color.error,
                size: 18,
              ),
              const SizedBox(width: Spacing.md),
              Text(
                title,
                style: getBoldStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: color.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Language option widget for bottom sheet
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
  final l10n = AppLocalizations.of(context)!;
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
              l10n.select_language,
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
