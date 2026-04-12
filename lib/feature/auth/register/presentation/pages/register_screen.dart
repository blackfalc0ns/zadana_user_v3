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

      context.pushNamed(
        AppRoutes.verifyOtp,
        arguments: _submittedIdentifier,
      );
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
              !state.isLoading &&
              !state.isSuccess &&
              state.failure != null;

          return AuthExperienceShell(
            showBackButton: true,
            heroBadge: 'Ø§Ø¨Ø¯Ø£ Ø±Ø­Ù„ØªÙƒ Ø§Ù„Ø´Ø±Ø§Ø¦ÙŠØ©',
            heroTitle: 'Ø¥Ù†Ø´Ø§Ø¡ Ø­Ø³Ø§Ø¨',
            heroSubtitle:
                'Ø£Ù†Ø´Ø¦ Ø­Ø³Ø§Ø¨Ùƒ Ø¨Ø³Ù‡ÙˆÙ„Ø© ÙˆØ§Ø¨Ø¯Ø£ ÙÙŠ Ø­ÙØ¸ Ø§Ù„Ø¹Ù†Ø§ÙˆÙŠÙ† ÙˆØ§Ù„Ø·Ù„Ø¨Ø§Øª ÙˆØ§Ù„Ø§Ø³ØªÙØ§Ø¯Ø© Ù…Ù† ØªØ¬Ø±Ø¨Ø© ØªØ³ÙˆÙ‚ Ù…Ø±ØªØ¨Ø© ÙˆØ³Ø±ÙŠØ¹Ø©.',
            sectionBadge: 'New account',
            sectionTitle: 'Ø³Ø¬Ù„ Ø­Ø³Ø§Ø¨ Ø¬Ø¯ÙŠØ¯',
            sectionDescription:
                'Ø§Ù…Ù„Ø£ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø£Ø³Ø§Ø³ÙŠØ© ÙÙ‚Ø· ÙˆØ³Ù†ÙƒÙ…Ù„ Ù…Ø¹Ùƒ Ø§Ù„ØªØ¬Ø±Ø¨Ø© Ø¨Ø´ÙƒÙ„ Ø¨Ø³ÙŠØ· ÙˆÙˆØ§Ø¶Ø­.',
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
                    locationEntity: widget.locationEntity ??
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
