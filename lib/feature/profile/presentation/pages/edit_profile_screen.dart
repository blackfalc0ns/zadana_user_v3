import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:zadana_user_v3/feature/profile/domain/entities/update_profile_request_entity.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_event.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_state.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_view_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _initControllers(ProfileState state) {
    if (_initialized) return;
    final profile = state.profileResponse;
    if (profile != null) {
      _nameController.text = profile.fullName;
      _emailController.text = profile.email;
      _phoneController.text = profile.phone;
      _initialized = true;
    }
  }

  Future<void> _pickAndUploadPhoto(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;
    final filePath = result.files.single.path;
    if (filePath == null) return;

    if (!mounted) return;
    context.read<ProfileViewModel>().doIntent(
      ProfileUpdatePhotoEvent(filePath),
    );
  }

  void _deletePhoto(BuildContext context) {
    context.read<ProfileViewModel>().doIntent(ProfileDeletePhotoEvent());
  }

  void _saveChanges(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

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

    return BlocConsumer<ProfileViewModel, ProfileState>(
      listenWhen: (prev, curr) =>
          prev.isUpdateSuccess != curr.isUpdateSuccess ||
          prev.isPhotoUpdateSuccess != curr.isPhotoUpdateSuccess ||
          prev.isPhotoDeleteSuccess != curr.isPhotoDeleteSuccess ||
          prev.updateFailure != curr.updateFailure ||
          prev.photoFailure != curr.photoFailure,
      listener: (context, state) {
        if (state.isUpdateSuccess) {
          CustomSnackbar.showSuccess(
            context: context,
            message: 'تم تحديث البيانات بنجاح',
          );
          Navigator.of(context).pop();
        }
        if (state.isPhotoUpdateSuccess) {
          CustomSnackbar.showSuccess(
            context: context,
            message: 'تم تحديث صورة البروفايل بنجاح',
          );
        }
        if (state.isPhotoDeleteSuccess) {
          CustomSnackbar.showSuccess(
            context: context,
            message: 'تم حذف صورة البروفايل',
          );
        }
        if (state.updateFailure != null) {
          CustomSnackbar.showError(
            context: context,
            message: state.updateFailure!.errorMessage,
          );
        }
        if (state.photoFailure != null) {
          CustomSnackbar.showError(
            context: context,
            message: state.photoFailure!.errorMessage,
          );
        }
      },
      builder: (context, state) {
        _initControllers(state);
        final profilePhotoUrl = state.profileResponse?.profilePhotoUrl;
        final isPhotoLoading = state.isPhotoUploading || state.isPhotoDeleting;

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
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                        backgroundImage: profilePhotoUrl != null
                            ? CachedNetworkImageProvider(profilePhotoUrl)
                            : null,
                        child: isPhotoLoading
                            ? const CircularProgressIndicator(strokeWidth: 2)
                            : profilePhotoUrl == null
                                ? Icon(
                                    Icons.person,
                                    color: AppColors.primary,
                                    size: 50,
                                  )
                                : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: isPhotoLoading
                              ? null
                              : () => _pickAndUploadPhoto(context),
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
                      if (profilePhotoUrl != null)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: GestureDetector(
                            onTap: isPhotoLoading
                                ? null
                                : () => _deletePhoto(context),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.surface,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                size: 14,
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
                    validator: (value) =>
                        Validations.validateName(context, value),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(height: Spacing.base),
                  FieldLabel(locale.label_email),
                  AppTextField(
                    controller: _emailController,
                    hint: locale.hint_email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        Validations.validateEmail(context, value),
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
                    onPressed: () => _saveChanges(context),
                    isLoading: state.isUpdating,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
