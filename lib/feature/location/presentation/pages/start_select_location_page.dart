import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_state.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/location_accuracy_dialog.dart';

class StartSelectLocationPage extends StatelessWidget {
  const StartSelectLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocationViewModel>(),
      child: const _StartSelectLocationView(),
    );
  }
}

class _StartSelectLocationView extends StatelessWidget {
  const _StartSelectLocationView();

  Future<void> _requestCurrentLocation(BuildContext context) async {
    final shouldContinue = await LocationAccuracyDialog.show(context);
    if (!shouldContinue || !context.mounted) {
      return;
    }

    context.read<LocationViewModel>().doIntent(
      const GetCurrentLocationEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
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
                  child: ApiErrorWidget.fromFailure(
                    state.failure!,
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
                  const SizedBox(height: Spacing.lg),
                  Center(
                    child: Image.asset(
                      Assets.logoDark,
                      height: 52,
                    ),
                  ),
                  const Spacer(),
                  const Text('الموقع', style: AppTextStyles.h2),
                  const SizedBox(height: Spacing.md),
                  Text(
                    state.selectedLocation != null
                        ? 'تم اختيار الموقع: ${state.selectedLocation!.addressLine}'
                        : 'حدد موقعك لنتمكن من توصيل طلباتك بسرعة ودقة',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Image.asset(Assets.locationImage),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.map),
                      label: const Text('اختيار الموقع من الخريطة'),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.selectAddress,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: Spacing.base),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: state.isLoading
                          ? null
                          : () => _requestCurrentLocation(context),
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : const Text('استخدام موقعي الحالي'),
                    ),
                  ),
                  const SizedBox(height: Spacing.base),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      child: const Text('أدخل العنوان يدويًا'),
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
