import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/widget/login_form_wrapper.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_state.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_view_model.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/auth_footer.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/auth_header.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/auth_toggle.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/sign_up_form.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';

/// Main authentication screen
/// Handles both login and signup
///
/// Architecture:
/// - AuthTabCubit → tab switching (via RegisterViewModel.isSignUp)
/// - LoginFormWrapper → provides LoginViewModel + handles side effects
/// - RegisterViewModel → register logic only
/// - Clean separation of concerns
///
/// Location: features/auth/register/presentation/pages/
class RegisterScreen extends StatefulWidget {
  final LocationEntity? locationEntity;
  
  const RegisterScreen({
    super.key,
    this.locationEntity,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? _registeredEmail;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return BlocProvider(
      create: (_) => getIt<RegisterViewModel>(),
      child: BlocListener<RegisterViewModel, RegisterState>(
        listener: (context, state) {
          if (state.isSuccess) {
            if (_registeredEmail != null && _registeredEmail!.isNotEmpty) {
              context.pushNamed(
                AppRoutes.verifyOtp,
                arguments: _registeredEmail,
              );
              CustomSnackbar.showSuccess(
                context: context,
                message: locale.register_success,
              );
            }
          }
          if (state.errorMessage != null) {
            CustomSnackbar.showError(
              context: context,
              message: state.errorMessage.toString(),
            );
          }
        },
        child: Scaffold(
          backgroundColor: color.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.screenH,
                vertical: Spacing.screenV,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with logo and title
                  const AuthHeader(),
                  SizedBox(height: Spacing.xl),

                  // Toggle between login/signup
                  const AuthToggle(),
                  SizedBox(height: Spacing.xl),

                  // Forms with animation
                  BlocBuilder<RegisterViewModel, RegisterState>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: AppConstants.tabSwitchDuration,
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: state.isSignUp
                            ? SignUpForm(
                                key: const ValueKey('signup'),
                                locationEntity: widget.locationEntity,
                                onEmailChanged: (email) {
                                  _registeredEmail = email;
                                },
                              )
                            : const LoginFormWrapper(key: ValueKey('login')),
                      );
                    },
                  ),
                //  SizedBox(height: Spacing.lg),

                  // Footer with toggle text
                  const AuthFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
