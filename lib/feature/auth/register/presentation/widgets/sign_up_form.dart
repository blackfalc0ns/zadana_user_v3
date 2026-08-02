import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/core/widgets/custom_text_field.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_state.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_view_model.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/field_label.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key, this.locationEntity, this.onEmailChanged});
  final LocationEntity? locationEntity;
  final Function(String)? onEmailChanged;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _hasAcceptedTerms = false;
  bool _showTermsError = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    final isFormValid = _formKey.currentState!.validate();
    if (!_hasAcceptedTerms) {
      setState(() => _showTermsError = true);
      return;
    }

    if (isFormValid) {
      widget.onEmailChanged?.call(_emailController.text);

      final location = widget.locationEntity;

      final registerRequestEntity = RegisterRequestEntity(
        fullName: _fullNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        addressLine: location?.addressLine ?? '',
        label: location?.label ?? '',
        buildingNo: location?.buildingNo ?? '',
        floorNo: location?.floorNo ?? '',
        apartmentNo: location?.apartmentNo ?? '',
        city: location?.city ?? '',
        area: location?.area ?? '',
        latitude: location?.latitude ?? 0.0,
        longitude: location?.longitude ?? 0.0,
      );

      context.read<RegisterViewModel>().register(registerRequestEntity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return BlocBuilder<RegisterViewModel, RegisterState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldLabel(locale.label_full_name),
              CustomTextField(
                controller: _fullNameController,
                hint: locale.hint_full_name,
                keyboardType: TextInputType.name,
                validator: (v) => Validations.validateName(context, v),
                prefix: Icon(
                  Icons.person_outline_rounded,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.base),

              FieldLabel(locale.label_email_or_phone),
              CustomTextField(
                controller: _emailController,
                hint: locale.hint_email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => Validations.validateEmail(context, v),
                prefix: Icon(
                  Icons.email_outlined,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.base),

              FieldLabel(locale.label_phone),
              CustomTextField(
                controller: _phoneController,
                hint: locale.hint_phone,
                //validator: (v) => Validations.validatePhoneNumber(context, v),
                prefix: Icon(
                  Icons.phone_outlined,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.base),

              FieldLabel(locale.label_password),
              CustomTextField(
                controller: _passwordController,
                hint: locale.hint_password,
                obscureText: _obscurePassword,
                validator: (v) => Validations.validatePassword(context, v),
                prefix: Icon(
                  Icons.lock_outline_rounded,
                  color: color.onSurfaceVariant,
                ),
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: color.onSurfaceVariant,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              const SizedBox(height: Spacing.md),
              _TermsAcceptanceField(
                value: _hasAcceptedTerms,
                showError: _showTermsError,
                onChanged: (value) {
                  setState(() {
                    _hasAcceptedTerms = value ?? false;
                    _showTermsError = !_hasAcceptedTerms;
                  });
                },
                onOpenTerms: () =>
                    Navigator.of(context).pushNamed(AppRoutes.termsConditions),
                onOpenPrivacy: () =>
                    Navigator.of(context).pushNamed(AppRoutes.privacyPolicy),
              ),
              const SizedBox(height: Spacing.xxl),
              AppButtonSwitch(
                label: locale.btn_signup,
                onPressed: _hasAcceptedTerms ? () => _onSubmit(context) : null,
                isLoading: state.isLoading,
              ),
              const SizedBox(height: Spacing.base),
            ],
          ),
        );
      },
    );
  }
}

class _TermsAcceptanceField extends StatelessWidget {
  const _TermsAcceptanceField({
    required this.value,
    required this.showError,
    required this.onChanged,
    required this.onOpenTerms,
    required this.onOpenPrivacy,
  });

  final bool value;
  final bool showError;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onOpenTerms;
  final VoidCallback onOpenPrivacy;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(value: value, onChanged: onChanged),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  children: [
                    Text(locale.sign_up_terms_prefix),
                    InkWell(
                      onTap: onOpenTerms,
                      child: Text(
                        locale.terms_conditions,
                        style: TextStyle(
                          color: color.primary,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(locale.sign_up_terms_and),
                    InkWell(
                      onTap: onOpenPrivacy,
                      child: Text(
                        locale.privacy_policy,
                        style: TextStyle(
                          color: color.primary,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(locale.sign_up_terms_suffix),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (showError)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 12),
            child: Text(
              locale.sign_up_terms_required,
              style: TextStyle(color: color.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
