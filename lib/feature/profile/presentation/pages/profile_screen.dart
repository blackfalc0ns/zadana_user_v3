import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_content_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: AppBar(
        backgroundColor: color.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.profile_title,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            color: color.onSurface,
            fontSize: 14,
          ),
        ),
        centerTitle: true,
      ),
      body: ProfileContent(l10n: l10n, onLogout: () {}),
    );
  }
}
