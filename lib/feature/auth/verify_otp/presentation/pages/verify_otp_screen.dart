import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/manager/verify_otp_state.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/manager/verify_otp_view_model.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/widget/verify_otp_form.dart';

/// Verify OTP screen for account verification
class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key, this.identifier});

  final String? identifier;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VerifyOtpViewModel>(),
      child: BlocListener<VerifyOtpViewModel, VerifyOtpState>(
        listener: _handleStateChanges,
        child: Scaffold(
          backgroundColor: context.colorScheme.surface,
          appBar: _buildAppBar(context),
          body: _buildBody(context),
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, VerifyOtpState state) {
    if (state.isSuccess) {
      CustomSnackbar.showSuccess(
        context: context,
        message: state.verifyOtpResponse?.message ?? 
                 AppLocalizations.of(context)!.otp_success_message,
      );
      context.pushReplacementNamed(AppRoutes.mainShell);
    }
    
    if (state.errorMessage != null) {
      CustomSnackbar.showError(
        context: context,
        message: state.errorMessage.toString(),
      );
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: context.colorScheme.onSurface),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.screenH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, localizations),
            const SizedBox(height: Spacing.xl),
            VerifyOtpForm(identifier: identifier ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.otp_screen_title,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          localizations.otp_screen_subtitle,
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
