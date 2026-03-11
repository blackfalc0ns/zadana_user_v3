import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(Spacing.base),
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showLogoutDialog(context, l10n),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.error),
          foregroundColor: colorScheme.error,
        ),
        child: Text(l10n.logout),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logout_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              CustomSnackbar.showSuccess(
                context: context,
                message: 'Logged out successfully',
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}
