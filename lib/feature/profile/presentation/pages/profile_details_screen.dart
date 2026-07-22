import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/account_close_helper.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/app_phone_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/field_label.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/update_profile_request_entity.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_event.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_state.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_view_model.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key, required this.profile});

  final ProfileResponseEntity profile;

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.fullName);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);

    _nameController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
    _phoneController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkForChanges);
    _emailController.removeListener(_checkForChanges);
    _phoneController.removeListener(_checkForChanges);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final changed =
        _nameController.text.trim() != widget.profile.fullName ||
        _emailController.text.trim() != widget.profile.email ||
        _phoneController.text.trim() != widget.profile.phone;

    if (changed != _hasChanges) {
      setState(() => _hasChanges = changed);
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    context.read<ProfileViewModel>().doIntent(
      ProfileUpdateEvent(
        UpdateProfileRequestEntity(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
        ),
      ),
    );
  }

  Future<void> _showCloseAccountDialog() async {
    final closed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AccountCloseDialog(),
    );

    if (closed == true && mounted) {
      await AccountCloseHelper.complete(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(title: locale.personal_info),
      body: SafeArea(
        child: BlocConsumer<ProfileViewModel, ProfileState>(
          listenWhen: (previous, current) =>
              previous.isUpdating != current.isUpdating ||
              previous.isUpdateSuccess != current.isUpdateSuccess ||
              previous.updateFailure != current.updateFailure,
          listener: (context, state) {
            if (state.isUpdating != _isSaving) {
              setState(() => _isSaving = state.isUpdating);
            }

            if (state.isUpdateSuccess && state.profileResponse != null) {
              CustomSnackbar.showSuccess(
                context: context,
                message: _updateSuccessMessage(context),
              );
              Navigator.of(context).pop(state.profileResponse);
            }
          },
          builder: (context, state) {
            final currentProfile = state.profileResponse ?? widget.profile;

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.base,
                    Spacing.base,
                    Spacing.base,
                    Spacing.xxl,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileDetailsHeader(profile: currentProfile),
                        const SizedBox(height: Spacing.base),
                        _ProfileInfoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FieldLabel(locale.label_full_name),
                              AppTextField(
                                controller: _nameController,
                                hint: locale.hint_full_name,
                                keyboardType: TextInputType.name,
                                validator: (v) =>
                                    Validations.validateName(context, v),
                                prefixIcon: Icon(
                                  Icons.person_outline_rounded,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: Spacing.base),
                              FieldLabel(locale.label_email),
                              AppTextField(
                                controller: _emailController,
                                hint: locale.hint_email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) =>
                                    Validations.validateEmail(context, v),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: Spacing.base),
                              FieldLabel(locale.label_phone),
                              AppPhoneField(
                                controller: _phoneController,
                                hint: locale.hint_phone,
                                validator: (v) =>
                                    Validations.validatePhoneNumber(context, v),
                              ),
                            ],
                          ),
                        ),
                        if (state.updateFailure != null) ...[
                          const SizedBox(height: Spacing.base),
                          InlineApiErrorWidget(
                            failure: state.updateFailure!,
                            onRetry: _onSave,
                          ),
                        ],
                        const SizedBox(height: Spacing.xl),
                        AppButtonSwitch(
                          label: _updateButtonLabel(context),
                          onPressed: _hasChanges ? _onSave : null,
                        ),
                        const SizedBox(height: Spacing.lg),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _isSaving
                                ? null
                                : _showCloseAccountDialog,
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: Text(
                              context.localization.account_close_action,
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.error,
                              side: BorderSide(color: colorScheme.error),
                              padding: const EdgeInsets.symmetric(
                                vertical: Spacing.md,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isSaving)
                  Positioned.fill(
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.18),
                      child: const CustomProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _updateButtonLabel(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode == 'ar') {
      return 'تحديث';
    }
    return 'Update';
  }

  String _updateSuccessMessage(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode == 'ar') {
      return 'تم تحديث البيانات بنجاح';
    }
    return 'Profile updated successfully';
  }
}

class AccountCloseDialog extends StatefulWidget {
  const AccountCloseDialog({super.key});

  @override
  State<AccountCloseDialog> createState() => _AccountCloseDialogState();
}

class _AccountCloseDialogState extends State<AccountCloseDialog> {
  final _confirmationController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  String? _error;

  bool get _canSubmit =>
      _confirmationController.text == 'DELETE' &&
      _passwordController.text.isNotEmpty &&
      !_isSubmitting;

  @override
  void initState() {
    super.initState();
    _confirmationController.addListener(_onInputChanged);
    _passwordController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _confirmationController
      ..removeListener(_onInputChanged)
      ..dispose();
    _passwordController
      ..removeListener(_onInputChanged)
      ..dispose();
    super.dispose();
  }

  void _onInputChanged() => setState(() => _error = null);

  Future<void> _submit() async {
    if (!_canSubmit) return;
    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    final result = await safeApiCall(
      () => getIt<ApiServices>().closeAccount({
        'confirmation': _confirmationController.text,
        'password': _passwordController.text,
      }),
    );

    if (!mounted) return;
    switch (result) {
      case ApiSuccessResult():
        Navigator.of(context).pop(true);
      case ApiErrorResult():
        if (result.failure.exception.backendErrorCode ==
            'ACCOUNT_ALREADY_CLOSED') {
          Navigator.of(context).pop(true);
          return;
        }
        setState(() {
          _isSubmitting = false;
          _error = _messageForErrorCode(
            result.failure.exception.backendErrorCode,
            result.failure.errorMessage,
          );
        });
    }
  }

  String _messageForErrorCode(String? errorCode, String fallback) {
    final l10n = context.localization;
    return switch (errorCode) {
      'ACCOUNT_CLOSE_CONFIRMATION_REQUIRED' =>
        l10n.account_close_confirmation_required,
      'ACCOUNT_CLOSE_PASSWORD_REQUIRED' => l10n.account_close_password_required,
      'ACCOUNT_CLOSE_INVALID_PASSWORD' => l10n.account_close_invalid_password,
      _ => fallback,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      icon: Icon(Icons.warning_amber_rounded, color: colorScheme.error),
      title: Text(l10n.account_close_title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.account_close_description),
            const SizedBox(height: Spacing.lg),
            AppTextField(
              controller: _confirmationController,
              label: l10n.account_close_confirmation_label,
              hint: 'DELETE',
              textInputAction: TextInputAction.next,
              autofocus: true,
            ),
            const SizedBox(height: Spacing.md),
            AppTextField(
              controller: _passwordController,
              label: l10n.label_password,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: Spacing.sm),
              Text(_error!, style: TextStyle(color: colorScheme.error)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _canSubmit ? _submit : null,
          style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.account_close_action),
        ),
      ],
    );
  }
}

class _ProfileDetailsHeader extends StatelessWidget {
  const _ProfileDetailsHeader({required this.profile});

  final ProfileResponseEntity profile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.24),
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.person, color: Colors.white, size: 42),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            profile.fullName,
            textAlign: TextAlign.center,
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.email,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            profile.phone,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.84),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = context.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark
        ? Color.alphaBlend(
            colorScheme.primary.withValues(alpha: 0.08),
            colorScheme.surfaceContainerHigh,
          )
        : Colors.white;
    final fieldFillColor = isDark
        ? colorScheme.surface.withValues(alpha: 0.92)
        : colorScheme.surface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.10 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            fillColor: fieldFillColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Spacing.inputRadius),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Spacing.inputRadius),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
