import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_event.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_state.dart';
import 'package:zadana_user_v3/feature/profile/presentation/manager/profile_view_model.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_content_widget.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_loading_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => getIt<ProfileViewModel>()
        ..doIntent(ProfileLoadEvent()),
      child: BlocListener<ProfileViewModel, ProfileState>(
        listener: (context, state) {
          if (state.errorMessage != null && !state.isSuccess) {
            CustomSnackbar.showError(
              context: context,
              message: state.errorMessage!,
            );
          }
        },
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(l10n.profile_title),
            centerTitle: true,
          ),
          body: BlocBuilder<ProfileViewModel, ProfileState>(
            builder: (context, state) {
              // Loading State
              if (state.isLoading) {
                return const ProfileLoadingWidget();
              }

              // Error State
              if (state.errorMessage != null &&
                  state.profileResponse == null) {
                return SizedBox() ;
                // ProfileErrorWidget(
                //   errorMessage: state.errorMessage!,
                //   onRetry: () => context
                //       .read<ProfileViewModel>()
                //       .doIntent(ProfileLoadEvent()),
                // );
              }

              // No Data State
              final profile = state.profileResponse;
              if (profile == null) {
                return const Center(
                  child: Text('No data available'),
                );
              }

              // Success State
              return ProfileContentWidget(
                profile: profile,
                onHeaderTap: () => _navigateToProfileDetails(
                  context,
                  profile,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _navigateToProfileDetails(
    BuildContext context,
    dynamic profile,
  ) {
    Navigator.pushNamed(
      context,
      AppRoutes.profileDetails,
      arguments: profile,
    );
  }
}
