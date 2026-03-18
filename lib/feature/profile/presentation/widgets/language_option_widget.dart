import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class LanguageOptionWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageOptionWidget({
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
          color: isSelected
              ? color.primary.withValues(alpha: 0.1)
              : color.surface,
          borderRadius: BorderRadius.circular(Spacing.sm),
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
        style: getRegularStyle(
          fontSize: FontSize.size12,
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
