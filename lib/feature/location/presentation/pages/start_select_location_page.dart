import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_state.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
          child: BlocConsumer<LocationViewModel, LocationState>(
            listener: (context, state) {
              // Handle current location success ONLY (not manual entry)
              if (state.isSuccess && 
                  state.selectedLocation != null && 
                  !state.isLoading &&
                  state.selectedLocation!.latitude != 0.0 && // Ensure it's not manual entry
                  state.selectedLocation!.longitude != 0.0) {
                // Clear the success state to prevent repeated navigation
                context.read<LocationViewModel>().doIntent(const ClearLocationSuccessEvent());
                
                // Navigate to building details page with location data
                Navigator.pushNamed(
                  context,
                  AppRoutes.buildingDetails,
                  arguments: state.selectedLocation,
                );
              }

              // Handle errors
              if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
                // Check if it's a location permission error
                if (state.errorMessage!.contains('إعدادات التطبيق') || 
                    state.errorMessage!.contains('خدمة الموقع غير مفعلة')) {
                  _showLocationPermissionDialog(context, state.errorMessage!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
                
                // Clear error after showing
                context.read<LocationViewModel>().doIntent(const ClearLocationErrorEvent());
              }
            },
            builder: (context, state) {
              final vm = context.read<LocationViewModel>();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Spacing.lg),

                  Center(
                    child: Image.asset(
                      AppConstants.logoLight,
                      height: 52,
                    ),
                  ),

                  const Spacer(),

                  Text('الموقع', style: AppTextStyles.h2),

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
                    child: Image.asset(AppConstants.locationImage),
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
                          : () {
                              vm.doIntent(const GetCurrentLocationEvent());
                            },
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
                      child: const Text('أدخل العنوان يدوياً'),
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

  void _showLocationPermissionDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'إذن الوصول للموقع',
            style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
          ),
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'إلغاء',
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                
                // Open app settings if permission denied forever
                if (message.contains('إعدادات التطبيق')) {
                  await Geolocator.openAppSettings();
                } else if (message.contains('خدمة الموقع غير مفعلة')) {
                  await Geolocator.openLocationSettings();
                }
              },
              child: Text(
                message.contains('إعدادات التطبيق') 
                    ? 'فتح إعدادات التطبيق'
                    : 'فتح إعدادات الموقع',
              ),
            ),
          ],
        );
      },
    );
  }
}
