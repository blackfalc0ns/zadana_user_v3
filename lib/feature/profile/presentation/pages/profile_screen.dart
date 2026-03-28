import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_dashboard_content.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  Future<void> _showLogoutDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.logout),
          content: Text(l10n.logout_confirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && context.mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ProfileDashboardContent(
        l10n: l10n,
        notificationsEnabled: _notificationsEnabled,
        onNotificationsChanged: (value) {
          setState(() => _notificationsEnabled = value);
        },
        onLogout: () => _showLogoutDialog(context, l10n),
      ),
    );
  }
}
