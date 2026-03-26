import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_state.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_view_model.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/register_footer.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/sign_up_header.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/sign_up_form.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';

/// Sign up screen
/// Handles user registration only
///
/// Location: features/auth/register/presentation/pages/
class SignUpScreen extends StatefulWidget {
  final LocationEntity? locationEntity;
  
  const SignUpScreen({
    super.key,
    this.locationEntity,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                // horizontal: Spacing.xl,
                vertical: Spacing.screenV,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sign up header
                  const SignUpHeader(),
                  
                  // Sign up form
                  SignUpForm(
                    locationEntity: widget.locationEntity,
                    onEmailChanged: (email) {
                      _registeredEmail = email;
                    },
                  ),

                  // Footer with toggle text
                  const RegisterFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
