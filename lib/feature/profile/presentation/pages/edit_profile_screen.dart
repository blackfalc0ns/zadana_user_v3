import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/field_label.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'محمد أحمد');
  final _emailController = TextEditingController(text: 'mohamed@example.com');
  final _phoneController = TextEditingController(text: '01012345678');
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (!mounted) return;

    CustomSnackbar.showSuccess(
      context: context,
      message: 'تم تحديث البيانات بنجاح',
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'تعديل الحساب',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.screenH),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: Spacing.base),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      'م',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Change profile image
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface,
                            width: 3,
                          ),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.camera,
                          size: 16,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xl),
              FieldLabel(locale.label_full_name),
              AppTextField(
                controller: _nameController,
                hint: locale.hint_full_name,
                validator: (value) => Validations.validateName(context, value),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              const SizedBox(height: Spacing.base),
              FieldLabel(locale.label_email),
              AppTextField(
                controller: _emailController,
                hint: locale.hint_email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validations.validateEmail(context, value),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: Spacing.base),
              FieldLabel(locale.label_phone),
              AppTextField(
                controller: _phoneController,
                hint: locale.hint_phone,
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    Validations.validatePhoneNumber(context, value),
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              const SizedBox(height: Spacing.xl),
              AppButtonSwitch(
                label: locale.btn_confirm,
                onPressed: _saveChanges,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
