import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/helpers/logout_helper.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_dialogs.dart';
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
      barrierColor: Colors.black.withValues(alpha: 0.32),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(Spacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 30,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  l10n.logout,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  l10n.logout_confirm,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          l10n.cancel,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          l10n.logout,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        future: _resolveGuestMode(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const _ProfileLoadingSkeleton();
          }

          if (snapshot.data!) {
            return GuestProfileDashboardContent(
              l10n: l10n,
              onLogin: () => Navigator.of(context).pushNamed(AppRoutes.login),
              onSignUp: () => Navigator.of(context).pushNamed(AppRoutes.signUp),
              onLanguageTap: () => DrawerDialogs.showLanguageDialog(context),
            );
          }

          return BlocProvider(
            create: (_) =>
                getIt<ProfileViewModel>()..doIntent(ProfileLoadEvent()),
            child: BlocBuilder<ProfileViewModel, ProfileState>(
              builder: (context, state) {
                if (state.isLoading && state.profileResponse == null) {
                  return const _ProfileLoadingSkeleton();
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
                    onLanguageTap: () =>
                        DrawerDialogs.showLanguageDialog(context),
                  );
                }

                return ProfileDashboardContent(
                  l10n: l10n,
                  profile: profile,
                  notificationsEnabled: _notificationsEnabled,
                  onEditTap: () async {
                    final updatedProfile = await Navigator.of(context).pushNamed(
                      AppRoutes.profileDetails,
                      arguments: profile,
                    );
                    if (!context.mounted ||
                        updatedProfile is! ProfileResponseEntity) {
                      return;
                    }
                    context.read<ProfileViewModel>().doIntent(
                      ProfileSetLocalDataEvent(updatedProfile),
                    );
                  },
                  onNotificationsChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                  },
                  onLanguageTap: () =>
                      DrawerDialogs.showLanguageDialog(context),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
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
              colors: const [
                Color(0xFFF1F4F6),
                Color(0xFFF9FBFC),
                Color(0xFFF1F4F6),
              ],
            ),
          ),
        );
      },
    );
  }
}
