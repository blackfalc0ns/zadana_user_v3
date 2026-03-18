import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/language_bottom_sheet_widget.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/menu_tile_widget.dart';

class MenuListWidget extends StatelessWidget {
  const MenuListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: Column(
        children: [
          MenuTileWidget(
            icon: Iconsax.location,
            title: l10n.addresses,
            iconColor: color.onSurface,
            onTap: () {},
          ),
          MenuTileWidget(
            icon: Iconsax.heart,
            title: l10n.nav_orders,
            iconColor: color.onSurface,
            onTap: () {},
          ),
          const SizedBox(height: Spacing.xs),
          MenuTileWidget(
            icon: Iconsax.global,
            title: l10n.language,
            iconColor: color.onSurface,
            trailing: Text(
              'العربية',
              style: getRegularStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: color.onSurfaceVariant,
              ),
            ),
            onTap: () => LanguageBottomSheetWidget.show(context),
          ),
          MenuTileWidget(
            icon: Iconsax.notification,
            title: l10n.notifications,
            iconColor: color.onSurface,
            onTap: () {},
          ),
          MenuTileWidget(
            icon: Iconsax.lock,
            title: l10n.change_password,
            iconColor: color.onSurface,
            onTap: () {},
          ),
          MenuTileWidget(
            icon: Iconsax.information,
            title: l10n.help_support,
            iconColor: color.onSurface,
            onTap: () {},
          ),
          MenuTileWidget(
            icon: Iconsax.document,
            title: l10n.about_app,
            iconColor: color.onSurface,
            onTap: () {},
          ),
          MenuTileWidget(
            icon: Iconsax.logout,
            title: l10n.logout,
            iconColor: color.error,
            onTap: () {},
          ),
          SizedBox(height: Spacing.lg),
        ],
      ),
    );
  }
}
