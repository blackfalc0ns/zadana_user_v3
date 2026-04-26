import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_state.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';

class StartSelectLocationPage extends StatelessWidget {
  const StartSelectLocationPage({super.key, this.fromAddresses = false});

  final bool fromAddresses;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocationViewModel>(),
      child: _StartSelectLocationView(fromAddresses: fromAddresses),
    );
  }
}

class _StartSelectLocationView extends StatelessWidget {
  const _StartSelectLocationView({required this.fromAddresses});

  final bool fromAddresses;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
          child: BlocConsumer<LocationViewModel, LocationState>(
            listener: (context, state) {
              if (state.isSuccess &&
                  state.selectedLocation != null &&
                  !state.isLoading &&
                  state.selectedLocation!.latitude != 0.0 &&
                  state.selectedLocation!.longitude != 0.0) {
                context.read<LocationViewModel>().doIntent(
                  const ClearLocationSuccessEvent(),
                );

                Navigator.pushNamed(
                  context,
                  AppRoutes.buildingDetails,
                  arguments: state.selectedLocation,
                );
              }
            },
            builder: (context, state) {
              final vm = context.read<LocationViewModel>();
              final showGlobalError =
                  !state.isLoading &&
                  state.failure != null &&
                  state.selectedLocation == null;

              if (showGlobalError) {
                return Center(
                  child: ApiErrorWidget(
                      exception: state.failure!.exception,
                      onRetry: () {
                        vm.clearFeedback();
                      vm.doIntent(const GetCurrentLocationEvent());
                    },
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (fromAddresses) ...[
                    const SizedBox(height: Spacing.sm),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: color.onSurface,
                      ),
                    ),
                  ] else
                    const SizedBox(height: Spacing.lg),
                  Center(child: Image.asset(Assets.logoDark, height: 52)),
                  const Spacer(),
                  Text(
                    l10n.location_start_title,
                    style: AppTextStyles.h2.copyWith(
                      color: color.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(
                    state.selectedLocation != null
                        ? l10n.location_start_selected_subtitle(
                            state.selectedLocation!.addressLine,
                          )
                        : l10n.location_start_subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: color.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Center(child: Image.asset(Assets.locationImage)),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.map),
                      label: Text(l10n.location_select_on_map),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.selectAddress);
                      },
                    ),
                  ),
                  const SizedBox(height: Spacing.base),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: state.isLoading
                          ? null
                          : () => context.read<LocationViewModel>().doIntent(
                              const GetCurrentLocationEvent(),
                            ),
                      child: state.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: color.primary,
                              ),
                            )
                          : Text(l10n.location_use_current_location),
                    ),
                  ),
                  const SizedBox(height: Spacing.base),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      child: Text(l10n.location_enter_address_manually),
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRoutes.manualAddressEntry,
                        );

                        if (result is LocationEntity && context.mounted) {
                          vm.doIntent(SetSelectedLocationEvent(result));

                          Navigator.pushNamed(
                            context,
                            AppRoutes.buildingDetails,
                            arguments: result,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
