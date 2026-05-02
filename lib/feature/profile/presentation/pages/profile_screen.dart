import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/dialogue_utils.dart';
import 'package:zadana_user_v3/core/helpers/logout_helper.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/notification_device_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/core/utils/bloc_provider_utils.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_dialogs.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_cubit.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_state.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';
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
  bool _isUpdatingNotifications = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationsPreference();
  }

  Future<void> _loadNotificationsPreference() async {
    final enabled = await getIt<NotificationDeviceService>()
        .isNotificationsEnabled();
    if (!mounted) return;
    setState(() => _notificationsEnabled = enabled);
  }

  Future<bool> _resolveGuestMode() async {
    final token = await getIt<TokenService>().getToken();
    return token == null || token.isEmpty;
  }

  Future<void> _showLogoutDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final shouldLogout = await DialogueUtils.showCompactConfirmationDialog(
      context: context,
      title: l10n.logout,
      message: l10n.logout_confirm,
      confirmLabel: l10n.logout,
      cancelLabel: l10n.cancel,
      icon: Icons.logout_rounded,
      accentColor: context.colorScheme.error,
    );

    if (shouldLogout == true && context.mounted) {
      await LogoutHelper.performLogout(context);
    }
  }

  Future<void> _handleNotificationsChanged(bool value) async {
    if (_isUpdatingNotifications) return;
    final previousValue = _notificationsEnabled;

    setState(() {
      _notificationsEnabled = value;
      _isUpdatingNotifications = true;
    });

    final result = await getIt<NotificationDeviceService>()
        .setNotificationsEnabled(value);

    if (!mounted) return;

    switch (result) {
      case ApiSuccessResult<void>():
        CustomSnackbar.showSuccess(
          context: context,
          message: context.localization.notifications_preferences_saved,
        );
        break;
      case ApiErrorResult<void>():
        await getIt<NotificationDeviceService>()
            .saveNotificationsEnabledLocally(previousValue);
        if (!mounted) return;
        _notificationsEnabled = previousValue;
        break;
    }

    setState(() => _isUpdatingNotifications = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final globalCubit = maybeReadBloc<AppSectionGlobalCubit>(context);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: globalCubit != null
          ? BlocBuilder<AppSectionGlobalCubit, AppSectionGlobalState>(
              bloc: globalCubit,
              builder: (context, state) {
                if (!state.isAuthResolved) {
                  return const _ProfileLoadingSkeleton();
                }

                if (state.isGuest) {
                  return _buildGuestContent(context, l10n);
                }

                final sharedViewModel = maybeReadBloc<ProfileViewModel>(
                  context,
                );
                if (sharedViewModel == null) {
                  return const _ProfileLoadingSkeleton();
                }

                return BlocProvider.value(
                  value: sharedViewModel,
                  child: _buildAuthenticatedContent(l10n),
                );
              },
            )
          : FutureBuilder<bool>(
              future: _resolveGuestMode(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const _ProfileLoadingSkeleton();
                }

                if (snapshot.data!) {
                  return _buildGuestContent(context, l10n);
                }

                return BlocProvider(
                  create: (_) =>
                      getIt<ProfileViewModel>()..doIntent(ProfileLoadEvent()),
                  child: _buildAuthenticatedContent(l10n),
                );
              },
            ),
    );
  }

  Widget _buildGuestContent(BuildContext context, AppLocalizations l10n) {
    return GuestProfileDashboardContent(
      l10n: l10n,
      onLogin: () => Navigator.of(context).pushNamed(AppRoutes.login),
      onSignUp: () => Navigator.of(context).pushNamed(AppRoutes.signUp),
      onLanguageTap: () => DrawerDialogs.showLanguageDialog(context),
    );
  }

  Widget _buildAuthenticatedContent(AppLocalizations l10n) {
    return BlocBuilder<ProfileViewModel, ProfileState>(
      builder: (context, state) {
        if (state.isLoading && state.profileResponse == null) {
          return const _ProfileLoadingSkeleton();
        }

        if (state.failure != null && state.profileResponse == null) {
          return ApiErrorWidget(
              exception: state.failure!.exception,
              onRetry: () =>
                  context.read<ProfileViewModel>().doIntent(ProfileLoadEvent()),
          );
        }

        final profile = state.profileResponse;
        if (profile == null) {
          return const _ProfileLoadingSkeleton();
        }

        return ProfileDashboardContent(
          l10n: l10n,
          profile: profile,
          notificationsEnabled: _notificationsEnabled,
          notificationsUpdating: _isUpdatingNotifications,
          onEditTap: () async {
            final updatedProfile = await Navigator.of(
              context,
            ).pushNamed(AppRoutes.profileDetails, arguments: profile);
            if (!context.mounted || updatedProfile is! ProfileResponseEntity) {
              return;
            }
            context.read<ProfileViewModel>().doIntent(
              ProfileSetLocalDataEvent(updatedProfile),
            );
          },
          onNotificationsChanged: _handleNotificationsChanged,
          onNotificationsTap: () =>
              Navigator.of(context).pushNamed(AppRoutes.notifications),
          onLanguageTap: () => DrawerDialogs.showLanguageDialog(context),
          onLogout: () => _showLogoutDialog(context, l10n),
        );
      },
    );
  }
}

class _ProfileLoadingSkeleton extends StatelessWidget {
  const _ProfileLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.base,
              Spacing.xl,
              Spacing.base,
              Spacing.base,
            ),
            child: Column(
              children: [
                const _ShimmerBox(height: 170, radius: 28),
                const SizedBox(height: Spacing.base),
                const _ShimmerSection(lines: 3),
                const SizedBox(height: Spacing.base),
                const _ShimmerSection(lines: 3),
                const SizedBox(height: Spacing.base),
                const _ShimmerSection(lines: 4),
                const SizedBox(height: Spacing.base),
                const _ShimmerSection(lines: 1),
                SizedBox(height: mainShellBottomNavReservedSpace(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ShimmerSection extends StatelessWidget {
  const _ShimmerSection({required this.lines});

  final int lines;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.only(start: Spacing.xs, bottom: 10),
          child: _ShimmerBox(width: 110, height: 18, radius: 10),
        ),
        Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: color.outlineVariant),
          ),
          child: Column(
            children: [
              for (var index = 0; index < lines; index++) ...[
                Row(
                  children: [
                    const _ShimmerBox(width: 42, height: 42, radius: 14),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ShimmerBox(
                            width: index.isEven ? 140 : 120,
                            height: 14,
                            radius: 8,
                          ),
                          const SizedBox(height: 8),
                          _ShimmerBox(
                            width: index.isEven ? 180 : 160,
                            height: 11,
                            radius: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    const _ShimmerBox(width: 18, height: 18, radius: 9),
                  ],
                ),
                if (index != lines - 1) const SizedBox(height: Spacing.md),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox({
    this.width = double.infinity,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1.2 + (_controller.value * 2.4), 0),
              end: Alignment(-0.2 + (_controller.value * 2.4), 0),
              colors: [
                color.surfaceContainerLow,
                color.surfaceContainerHighest,
                color.surfaceContainerLow,
              ],
            ),
          ),
        );
      },
    );
  }
}
