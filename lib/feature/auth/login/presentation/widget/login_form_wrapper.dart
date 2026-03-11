import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/flutter_toast.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import '../manager/login_state.dart';
import '../manager/login_view_model.dart';
import 'sign_in_form.dart';

/// Login form wrapper with BlocProvider and BlocListener
/// Handles LoginViewModel lifecycle and side effects
///
/// Architecture:
/// - Provides LoginViewModel via BlocProvider
/// - Handles side effects via BlocListener
/// - Wraps existing LoginForm with minimal changes
class LoginFormWrapper extends StatelessWidget {
  const LoginFormWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return BlocProvider(
      create: (_) => getIt<LoginViewModel>(),
      child: BlocListener<LoginViewModel, LoginState>(
        listener: (context, state) {
          // Handle success - navigate to main screen
          if (state.isSuccess) {
            context.pushNamed(AppRoutes.mainShell);

            CustomSnackbar.showSuccess(
              context: context,
              message: 'تم تسجيل الدخول بنجاح',
            );
            // ToastMessage.toastMsg(
            //   'تم تسجيل الدخول بنجاح',
            //   backgroundColor: colorScheme.primary,
            // );
          }

          // Handle error - show error toast
          if (state.errorMessage != null) {
            CustomSnackbar.showError(
              context: context,
              message: state.errorMessage.toString(),
            );
            // ToastMessage.toastMsg(
            //   state.errorMessage!,
            //   backgroundColor: colorScheme.error,
            // );
          }
        },
        child: const LoginForm(),
      ),
    );
  }
}
