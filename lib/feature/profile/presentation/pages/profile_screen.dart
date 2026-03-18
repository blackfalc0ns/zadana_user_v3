import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/menu_list_widget.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_card_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: color.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: color.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.profile_title,
          style: getBoldStyle(
            fontSize: FontSize.size18,
            fontFamily: FontConstant.cairo,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: Spacing.sm),
            ProfileCardWidget(),
            const SizedBox(height: Spacing.sm),
            MenuListWidget(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
