import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/helpers/logout_helper.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_event.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_state.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_view_model.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_dashboard_content.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  late Future<bool> _isGuestFuture;

  @override
  void initState() {
    super.initState();
    _isGuestFuture = _resolveGuestMode();
  }

  Future<bool> _resolveGuestMode() async {
    final token = await getIt<TokenService>().getToken();
    return token == null || token.isEmpty;
  }

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
      await LogoutHelper.performLogout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<bool>(
        future: _isGuestFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!) {
            return GuestProfileDashboardContent(
              l10n: l10n,
              onLogin: () => Navigator.of(context).pushNamed(AppRoutes.login),
              onSignUp: () => Navigator.of(context).pushNamed(AppRoutes.signUp),
            );
          }

          return BlocProvider(
            create: (_) => getIt<ProfileViewModel>()..doIntent(ProfileLoadEvent()),
            child: BlocBuilder<ProfileViewModel, ProfileState>(
              builder: (context, state) {
                if (state.isLoading && state.profileResponse == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.failure != null && state.profileResponse == null) {
                  return ApiErrorWidget.fromFailure(
                    state.failure!,
                    onRetry: () => context.read<ProfileViewModel>().doIntent(
                      ProfileLoadEvent(),
                    ),
                  );
                }

                final profile = state.profileResponse;
                if (profile == null) {
                  return GuestProfileDashboardContent(
                    l10n: l10n,
                    onLogin: () =>
                        Navigator.of(context).pushNamed(AppRoutes.login),
                    onSignUp: () =>
                        Navigator.of(context).pushNamed(AppRoutes.signUp),
                  );
                }

                return ProfileDashboardContent(
                  l10n: l10n,
                  profile: profile,
                  notificationsEnabled: _notificationsEnabled,
                  onNotificationsChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                  },
                  onLogout: () => _showLogoutDialog(context, l10n),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
