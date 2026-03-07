import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import '../cubits/location_cubit.dart';
import '../cubits/location_state.dart';
import '../../data/datasources/location_datasource.dart';
import '../../data/repositories/location_repository.dart';

class SelectAddressFromMapPage extends StatelessWidget {
  const SelectAddressFromMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationCubit(
        repository: LocationRepositoryImpl(
          dataSource: LocationDataSourceImpl(),
        ),
      ),
      child: const _SelectAddressFromMapView(),
    );
  }
}

class _SelectAddressFromMapView extends StatefulWidget {
  const _SelectAddressFromMapView();

  @override
  State<_SelectAddressFromMapView> createState() =>
      _SelectAddressFromMapViewState();
}

class _SelectAddressFromMapViewState 
    extends State<_SelectAddressFromMapView> {
  late final MapController _mapController;
  final TextEditingController _searchController = 
      TextEditingController();

  // Cairo, Egypt default coordinates
  final ll.LatLng _initialPosition = 
      const ll.LatLng(30.0444, 31.2357);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocConsumer<LocationCubit, LocationState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'إعادة',
                  textColor: AppColors.white,
                  onPressed: () {
                    context.read<LocationCubit>().clearError();
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Map
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _initialPosition,
                  initialZoom: 13.0,
                  onPositionChanged: (camera, hasGesture) {
                    if (hasGesture) {
                      context.read<LocationCubit>().updateCoordinates(
                        camera.center,
                      );
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.zadana.user',
                  ),
                ],
              ),

              // Center pin icon
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 36),
                  child: Icon(
                    Icons.location_on,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
              ),

              // Top: Back button + Search bar
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: Spacing.base,
                right: Spacing.base,
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Back button
                        _CircleButton(
                          icon: Icons.arrow_back,
                          onTap: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: Spacing.md),
                        // Search bar
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                Spacing.cardRadius,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              style: AppTextStyles.bodyMedium,
                              decoration: InputDecoration(
                                hintText: 'ابحث عن موقع...',
                                hintStyle: AppTextStyles.inputHint,
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: AppColors.textSecondary,
                                  size: Spacing.iconMd,
                                ),
                                suffixIcon: _searchController
                                    .text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          size: 18,
                                          color: AppColors.textSecondary,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          context
                                              .read<LocationCubit>()
                                              .clearSearchResults();
                                          setState(() {});
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.base,
                                  vertical: Spacing.md,
                                ),
                              ),
                              onChanged: (query) {
                                setState(() {});
                                if (query.trim().length >= 3) {
                                  context
                                      .read<LocationCubit>()
                                      .searchLocations(query);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Search results dropdown
                    if (state.searchResults.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(
                          top: Spacing.sm,
                          left: 52,
                        ),
                        constraints: const BoxConstraints(
                          maxHeight: 250,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(
                            Spacing.cardRadius,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                            vertical: Spacing.sm,
                          ),
                          itemCount: state.searchResults.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            indent: Spacing.base,
                            endIndent: Spacing.base,
                          ),
                          itemBuilder: (context, index) {
                            final result = state.searchResults[index];
                            return ListTile(
                              dense: true,
                              leading: const Icon(
                                Icons.location_on,
                                color: AppColors.primary,
                                size: Spacing.iconMd,
                              ),
                              title: Text(
                                result.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodySmall,
                              ),
                              onTap: () {
                                _mapController.move(
                                  result.coordinates,
                                  15.0,
                                );
                                context
                                    .read<LocationCubit>()
                                    .selectLocation(
                                      result.coordinates.latitude,
                                      result.coordinates.longitude,
                                    );
                                _searchController.text = result.name;
                                context
                                    .read<LocationCubit>()
                                    .clearSearchResults();
                                FocusScope.of(context).unfocus();
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),

              // Loading indicator
              if (state.isLoading)
                const Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),

              // Bottom sheet: Selected address + Confirm
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    left: Spacing.lg,
                    right: Spacing.lg,
                    top: Spacing.lg,
                    bottom: MediaQuery.of(context).padding.bottom + 
                        Spacing.base,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(Spacing.bottomSheetRadius),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag handle
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(
                          bottom: Spacing.base,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Address info
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                Spacing.cardRadius,
                              ),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: 
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.selectedAddress ??
                                      'حرّك الخريطة لاختيار الموقع',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.labelMedium,
                                ),
                                if (state.selectedCoordinates != null)
                                  Text(
                                    '${state.selectedCoordinates!.latitude.toStringAsFixed(4)}, ${state.selectedCoordinates!.longitude.toStringAsFixed(4)}',
                                    style: AppTextStyles.bodySmall,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.base),

                      // Confirm button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () async {
                                  final center = 
                                      _mapController.camera.center;
                                  await context
                                      .read<LocationCubit>()
                                      .selectLocation(
                                        center.latitude,
                                        center.longitude,
                                      );
                                  if (context.mounted) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoutes.mainShell,
                                      (route) => false,
                                    );
                                  }
                                },
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.textOnPrimary,
                                  ),
                                )
                              : const Text('تأكيد الموقع'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
      ),
    );
  }
}