import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import '../manager/login_state.dart';
import '../manager/login_view_model.dart';
import 'sign_in_form.dart';

class LoginFormWrapper extends StatelessWidget {
  const LoginFormWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return const LoginForm();
  }
}
