import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_state.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_view_model.dart';
import 'package:zadana_user_v3/feature/auth/sign_in/presentation/widgets/sign_in_header.dart';
import 'package:zadana_user_v3/feature/auth/sign_in/presentation/widgets/sign_in_form.dart';
import 'package:zadana_user_v3/feature/auth/sign_in/presentation/widgets/sign_in_footer.dart';

/// Sign in screen
/// Handles user login only
///
/// Location: features/auth/sign_in/presentation/pages/
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return BlocProvider(
      create: (_) => getIt<LoginViewModel>(),
      child: BlocListener<LoginViewModel, LoginState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.pushNamed(AppRoutes.mainShell);
            CustomSnackbar.showSuccess(
              context: context,
              message: context.localization.login_success,
            );
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
                // horizontal: Spacing.screenH,
                vertical: Spacing.screenV,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sign in header
                  const SignInHeader(),
                  
                  // Sign in form
                  const SignInForm(),

                  // Footer with toggle text
                  const SignInFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
