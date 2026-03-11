import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/app_phone_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/field_label.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final ProfileResponseEntity profile;

  const ProfileDetailsScreen({
    super.key,
    required this.profile,
  });

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.fullName);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _roleController = TextEditingController(text: widget.profile.role);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save functionality with API call
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Name: ${_nameController.text}\n'
            'Email: ${_emailController.text}\n'
            'Phone: ${_phoneController.text}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(locale.personal_info),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.screenH,
            vertical: Spacing.screenV,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                FieldLabel(locale.label_full_name),
                AppTextField(
                  controller: _nameController,
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
                  validator: (v) => 
                      Validations.validatePhoneNumber(context, v),
                ),
                const SizedBox(height: Spacing.base),

                // Role (Read-only)
                FieldLabel('Role'),
                AppTextField(
                  controller: _roleController,
                  hint: 'User role',
                  enabled: false,
                  prefixIcon: Icon(
                    Icons.badge_outlined,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: Spacing.xxl),

                // Save button
                AppButtonSwitch(
                  label: 'Save Changes',
                  onPressed: _onSave,
                  isLoading: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
