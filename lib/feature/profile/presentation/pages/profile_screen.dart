import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:zadana_user_v3/feature/profile/presentation/cubit/profile_nav_event.dart';
import 'package:zadana_user_v3/feature/profile/presentation/cubit/profile_state.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_address_card.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_header.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_menu_item.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_section_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) => previous.isLoading != current.isLoading,
      listener: (context, state) {
        // Handle loading states if needed
      },
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // Listen to navigation events
          context.read<ProfileCubit>().navigationStream.listen((event) {
            _handleNavigation(context, event);
          });
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(automaticallyImplyLeading: false,
            title: Text(l10n.profile_title),
            centerTitle: true,
          ),
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ProfileHeader(onSettingsTap: (){},
                        fullName: state.fullName,
                        email: state.email,
                        avatarUrl: state.avatarUrl,
                      //  onEditAvatar: () => context.read<ProfileCubit>().editAvatar(),
                      ),
                    ),
                    
                    const SizedBox(height: Spacing.base),

                    // Personal Info Section
                    ProfileSectionCard(
                      title: l10n.personal_info,
                      children: [
                        ProfileMenuItem(
                          icon: Icons.person_outline,
                          title: l10n.name,
                          subtitle: state.fullName,
                          onTap: () => context.read<ProfileCubit>().updatePersonalInfo(),
                        ),
                        const Divider(height: 1),
                        if (state.phone != null)
                          ProfileMenuItem(
                            icon: Icons.phone_outlined,
                            title: l10n.phone,
                            subtitle: state.phone!,
                            onTap: () => context.read<ProfileCubit>().updatePersonalInfo(),
                          ),
                        if (state.phone != null) const Divider(height: 1),
                        if (state.dateOfBirth != null)
                          ProfileMenuItem(
                            icon: Icons.cake_outlined,
                            title: l10n.date_of_birth,
                            subtitle: state.dateOfBirth!,
                            onTap: () => context.read<ProfileCubit>().updatePersonalInfo(),
                          ),
                        if (state.dateOfBirth != null) const Divider(height: 1),
                        if (state.gender != null)
                          ProfileMenuItem(
                            icon: Icons.person_outline,
                            title: l10n.gender,
                            subtitle: state.gender!,
                            onTap: () => context.read<ProfileCubit>().updatePersonalInfo(),
                          ),
                      ],
                    ),

                    // Addresses Section
                    ProfileSectionCard(
                      title: l10n.addresses,
                      children: [
                        ...state.addresses.map(
                          (address) => ProfileAddressCard(
                            title: address.title,
                            address: address.fullAddress,
                            isDefault: address.isDefault,
                            onEdit: () => context.read<ProfileCubit>().editAddress(address),
                            onDelete: () => context.read<ProfileCubit>().deleteAddress(address),
                          ),
                        ),
                        ProfileMenuItem(
                          icon: Icons.add_location_outlined,
                          title: l10n.add_address,
                          onTap: () => context.read<ProfileCubit>().addAddress(),
                        ),
                      ],
                    ),

                    // Settings Section
                    ProfileSectionCard(
                      title: l10n.settings,
                      children: [
                        ProfileMenuItem(
                          icon: Icons.language_outlined,
                          title: l10n.language,
                          subtitle: state.currentLanguage == 'ar' ? 'العربية' : 'English',
                          trailing: Switch(
                            value: state.currentLanguage == 'ar',
                            onChanged: (value) {
                              context.read<ProfileCubit>().changeLanguage(value ? 'ar' : 'en');
                            },
                            activeColor: AppColors.primary,
                          ),
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.notifications_outlined,
                          title: l10n.notifications,
                          trailing: Switch(
                            value: state.notificationsEnabled,
                            onChanged: (value) => context.read<ProfileCubit>().toggleNotifications(value),
                            activeColor: AppColors.primary,
                          ),
                        ),
                        const Divider(height: 1),
                        // ProfileMenuItem(
                        //   icon: Icons.dark_mode_outlined,
                        //   title: l10n.dark_mode,
                        //   trailing: Switch(
                        //     value: state.isDarkMode,
                        //     onChanged: (value) => context.read<ProfileCubit>().toggleDarkMode(value),
                        //     activeColor: AppColors.primary,
                        //   ),
                        // ),
                      ],
                    ),

                    // Account Section
                    ProfileSectionCard(
                      title: l10n.account,
                      children: [
                        ProfileMenuItem(
                          icon: Icons.lock_outline,
                          title: l10n.change_password,
                          onTap: () => context.read<ProfileCubit>().changePassword(),
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.help_outline,
                          title: l10n.help_support,
                          onTap: () => context.read<ProfileCubit>().helpSupport(),
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.info_outline,
                          title: l10n.about_app,
                          onTap: () => context.read<ProfileCubit>().aboutApp(),
                        ),
                      ],
                    ),

                    // Legal Section
                    ProfileSectionCard(
                      title: l10n.legal,
                      children: [
                        ProfileMenuItem(
                          icon: Icons.description_outlined,
                          title: l10n.terms_conditions,
                          onTap: () => context.read<ProfileCubit>().termsConditions(),
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.privacy_tip_outlined,
                          title: l10n.privacy_policy,
                          onTap: () => context.read<ProfileCubit>().privacyPolicy(),
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.quiz_outlined,
                          title: l10n.faq,
                          onTap: () => context.read<ProfileCubit>().faq(),
                        ),
                      ],
                    ),

                    // Logout Button
                    Container(
                      margin: const EdgeInsets.all(Spacing.base),
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _showLogoutDialog(context, l10n),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.error),
                          foregroundColor: AppColors.error,
                        ),
                        child: Text(
                          l10n.logout,
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: Spacing.base),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, ProfileNavEvent event) {
    switch (event) {
      case NavigateToEditInfo():
        // TODO: Navigate to edit personal info screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigate to Edit Info')),
        );
        break;
      case NavigateToAddAddress():
        // TODO: Navigate to add address screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigate to Add Address')),
        );
        break;
      case NavigateToEditAddress():
        // TODO: Navigate to edit address screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigate to Edit Address')),
        );
        break;
      case NavigateToChangePassword():
        // TODO: Navigate to change password screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigate to Change Password')),
        );
        break;
      case NavigateToHelpSupport():
        // TODO: Navigate to help & support screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigate to Help & Support')),
        );
        break;
      case NavigateToAboutApp():
        // TODO: Navigate to about app screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigate to About App')),
        );
        break;
      case NavigateToTerms():
        // TODO: Navigate to terms & conditions screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigate to Terms & Conditions')),
        );
        break;
      case NavigateToPrivacyPolicy():
        // TODO: Navigate to privacy policy screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigate to Privacy Policy')),
        );
        break;
      case NavigateToFaq():
        // TODO: Navigate to FAQ screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigate to FAQ')),
        );
        break;
      case LoggedOut():
        // TODO: Navigate to login screen and clear user session
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out successfully')),
        );
        break;
    }
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logout_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ProfileCubit>().logout();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}