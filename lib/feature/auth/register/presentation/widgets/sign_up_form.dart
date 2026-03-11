import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_event.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_state.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_view_model.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/app_password_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/app_phone_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/field_label.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';

/// Sign up form widget
/// Following requirements:
/// - No setState
/// - Dispatches events to ViewModel
/// - Uses ColorScheme
class SignUpForm extends StatefulWidget {
  final LocationEntity? locationEntity;
  final Function(String)? onEmailChanged;

  const SignUpForm({
    super.key,
    this.locationEntity,
    this.onEmailChanged,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Notify parent about email
      widget.onEmailChanged?.call(_emailController.text);
      
      final location = widget.locationEntity;

      // Create entity
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

      // Dispatch event to ViewModel
      context.read<RegisterViewModel>().doIntent(
        RegisterSubmitEvent(registerRequestEntity: registerRequestEntity),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final colorScheme = context.colorScheme;

    return BlocBuilder<RegisterViewModel, RegisterState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Name
              FieldLabel(locale.label_full_name),
              AppTextField(
                controller: _fullNameController,
                hint: locale.hint_full_name,
                keyboardType: TextInputType.name,
                validator: (v) => Validations.validateName(context, v),
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.base),

              // Email
              FieldLabel(locale.label_email),
              AppTextField(
                controller: _emailController,
                hint: locale.hint_email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => Validations.validateEmail(context, v),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.base),

              // Phone
              FieldLabel(locale.label_phone),
              AppPhoneField(
                controller: _phoneController,
                hint: locale.hint_phone,
                validator: (v) => Validations.validatePhoneNumber(context, v),
              ),
              const SizedBox(height: Spacing.base),

              // Password
              FieldLabel(locale.label_password),
              AppPasswordField(
                controller: _passwordController,
                hint: locale.hint_password,
                validator: (v) => Validations.validatePassword(context, v),
              ),
              const SizedBox(height: Spacing.xxl),

              // Submit button
              AppButtonSwitch(
                label: locale.btn_signup,
                onPressed: () => _onSubmit(context),
                isLoading: state.isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
