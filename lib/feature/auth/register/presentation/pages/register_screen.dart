import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/saved_location_service.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_state.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_view_model.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/sign_up_form.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.locationEntity});

  final LocationEntity? locationEntity;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _submittedIdentifier = '';

  void _handleStateChanges(BuildContext context, RegisterState state) {
    if (state.isSuccess && state.registerResponseEntity != null) {
      context.read<RegisterViewModel>().clearFeedback();
      CustomSnackbar.showSuccess(
        context: context,
        message: state.registerResponseEntity!.message,
      );

      context.pushNamed(AppRoutes.verifyOtp, arguments: _submittedIdentifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocListener<RegisterViewModel, RegisterState>(
      listener: _handleStateChanges,
      child: BlocBuilder<RegisterViewModel, RegisterState>(
        builder: (context, state) {
          final showGlobalError =
              !state.isLoading && !state.isSuccess && state.failure != null;

          return AuthExperienceShell(
            isLoading: state.isLoading,
            showBackButton: true,
            heroBadge: locale.register_hero_badge,
            heroTitle: locale.register_screen_title,
            heroSubtitle: locale.register_hero_subtitle,
            sectionBadge: locale.register_section_badge,
            sectionTitle: locale.register_form_title,
            sectionDescription: locale.register_form_description,
            sectionIcon: Icons.person_add_alt_1_rounded,
            body: showGlobalError
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: Spacing.lg,
                    ),
                    child: ApiErrorWidget.fromFailure(
                      state.failure!,
                      onRetry: context.read<RegisterViewModel>().clearFeedback,
                    ),
                  )
                : SignUpForm(
                    locationEntity:
                        widget.locationEntity ??
                        SavedLocationService.getSavedLocation(),
                    onEmailChanged: (identifier) {
                      _submittedIdentifier = identifier;
                    },
                  ),
            footer: AuthPromptText(
              text: locale.footer_have_account,
              actionLabel: locale.toggle_login,
              onTap: () => context.pushReplacementNamed(AppRoutes.login),
            ),
          );
        },
      ),
    );
  }
}
