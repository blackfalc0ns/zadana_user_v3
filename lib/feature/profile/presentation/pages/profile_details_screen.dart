import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.fullName);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final colorScheme = context.colorScheme;

    return Scaffold(
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
                message: context.localization.btn_confirm,
              );
              Navigator.of(context).pop(state.profileResponse);
            }
          },
          builder: (context, state) {
            final currentProfile = state.profileResponse ?? widget.profile;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                Spacing.base,
                Spacing.base,
                Spacing.base,
                Spacing.xl,
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
                      label: locale.btn_confirm,
                      onPressed: _onSave,
                      isLoading: _isSaving,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileDetailsHeader extends StatelessWidget {
  const _ProfileDetailsHeader({required this.profile});

  final ProfileResponseEntity profile;

  @override
  Widget build(BuildContext context) {
    final initial = profile.fullName.trim().isNotEmpty
        ? profile.fullName.trim()[0].toUpperCase()
        : 'Z';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primarygradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 14),
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
            child: Text(
              initial,
              style: AppTextStyles.h1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 32,
              ),
            ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
