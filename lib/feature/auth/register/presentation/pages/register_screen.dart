import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/widget/login_form_wrapper.dart';
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
class RegisterScreen extends StatelessWidget {
  final LocationEntity? locationEntity;

  const RegisterScreen({
    super.key,
    this.locationEntity,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final isSignUp = context.select<RegisterViewModel, bool>(
      (viewModel) => viewModel.state.isSignUp,
    );

    return Scaffold(
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
              AnimatedSwitcher(
                duration: AppConstants.tabSwitchDuration,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: isSignUp
                    ? SignUpForm(
                        key: const ValueKey('signup'),
                        locationEntity: locationEntity,
                      )
                    : const LoginFormWrapper(key: ValueKey('login')),
              ),

              //  SizedBox(height: Spacing.lg),

              // Footer with toggle text
              const AuthFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
