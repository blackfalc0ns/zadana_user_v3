import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_state.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';
import 'package:zadana_user_v3/feature/location/presentation/pages/widget/circle_action_button.dart';
import 'package:zadana_user_v3/feature/location/presentation/pages/widget/location_botton_sheet.dart';
import 'package:zadana_user_v3/feature/location/presentation/pages/widget/location_search_bar.dart';
import 'package:zadana_user_v3/feature/location/presentation/pages/widget/location_search_result_list.dart';

class SelectAddressFromMapPage extends StatelessWidget {
  const SelectAddressFromMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocationViewModel>(),
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

class _SelectAddressFromMapViewState extends State<_SelectAddressFromMapView> {
  late final MapController _mapController;
  final TextEditingController _searchController = TextEditingController();

  final ll.LatLng _initialPosition = const ll.LatLng(24.7136, 46.6753);

  Timer? _mapReverseDebounce;
  bool _isConfirmingLocation = false;
  bool _shouldCenterOnCurrentLocation = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Ask for the device location as soon as this screen opens so the map
    // pin starts at the user's current position instead of the fallback city.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showCurrentLocation();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapReverseDebounce?.cancel();
    super.dispose();
  }

  void _debouncedReverseLookup(ll.LatLng center) {
    _mapReverseDebounce?.cancel();
    _mapReverseDebounce = Timer(const Duration(milliseconds: 2000), () {
      if (!mounted || _isConfirmingLocation) return;

      context.read<LocationViewModel>().doIntent(
        GetAddressFromCoordinatesEvent(
          latitude: center.latitude,
          longitude: center.longitude,
        ),
      );
    });
  }

  void _confirmCurrentCenter() {
    final center = _mapController.camera.center;
    _isConfirmingLocation = true;

    context.read<LocationViewModel>().doIntent(
      const ClearLocationSuccessEvent(),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      context.read<LocationViewModel>().doIntent(
        GetAddressFromCoordinatesEvent(
          latitude: center.latitude,
          longitude: center.longitude,
        ),
      );
    });
  }

  void _showCurrentLocation() {
    _shouldCenterOnCurrentLocation = true;
    context.read<LocationViewModel>().doIntent(const GetCurrentLocationEvent());
  }

  void _retryLastAction(BuildContext context) {
    final viewModel = context.read<LocationViewModel>();
    viewModel.clearFeedback();

    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      viewModel.doIntent(SearchLocationSubmitEvent(query));
      return;
    }

    final center = _mapController.camera.center;
    viewModel.doIntent(
      GetAddressFromCoordinatesEvent(
        latitude: center.latitude,
        longitude: center.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Scaffold(
      body: BlocConsumer<LocationViewModel, LocationState>(
        listener: (context, state) {
          final currentLocation = state.selectedLocation;
          if (_shouldCenterOnCurrentLocation &&
              !state.isLoading &&
              currentLocation != null) {
            _shouldCenterOnCurrentLocation = false;
            _mapController.move(
              ll.LatLng(currentLocation.latitude, currentLocation.longitude),
              16,
            );
          }

          if (_isConfirmingLocation && !state.isLoading) {
            if (state.selectedLocation != null) {
              _isConfirmingLocation = false;

              Navigator.pushReplacementNamed(
                context,
                AppRoutes.buildingDetails,
                arguments: state.selectedLocation,
              );
            } else if (state.failure == null) {
              _isConfirmingLocation = false;
            }
          }
        },
        builder: (context, state) {
          final vm = context.read<LocationViewModel>();
          final showGlobalError =
              !state.isLoading &&
              !state.isSearchLoading &&
              state.failure != null &&
              state.selectedLocation == null;

          if (showGlobalError) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.screenH),
                child: ApiErrorWidget(
                  exception: state.failure!.exception,
                  onRetry: () => _retryLastAction(context),
                  onGoBack: () => Navigator.pop(context),
                ),
              ),
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _initialPosition,
                  onPositionChanged: (camera, hasGesture) {
                    if (!hasGesture) return;
                    _debouncedReverseLookup(camera.center);
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 36),
                  child: Icon(
                    Icons.location_on,
                    size: 48,
                    color: color.primary,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: Spacing.base,
                right: Spacing.base,
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleActionButton(
                          icon: Icons.arrow_back,
                          onTap: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: Spacing.md),
                        Expanded(
                          child: LocationSearchBar(
                            controller: _searchController,
                            onChanged: (query) {
                              vm.doIntent(
                                SearchLocationQueryChangedEvent(query),
                              );
                              setState(() {});
                            },
                            onClear: () {
                              _searchController.clear();
                              vm.doIntent(
                                const SearchLocationQueryChangedEvent(''),
                              );
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    LocationSearchResultsList(
                      results: state.searchResults,
                      onSelect: (result) {
                        _mapController.move(
                          ll.LatLng(result.latitude, result.longitude),
                          15,
                        );

                        vm.doIntent(SelectSearchedLocationEvent(result));
                        _searchController.text = result.addressLine;
                        FocusScope.of(context).unfocus();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              if (state.isLoading || state.isSearchLoading)
                Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircularProgressIndicator(color: color.primary),
                  ),
                ),
              Positioned(
                right: Spacing.base,
                bottom: 210,
                child: CircleActionButton(
                  icon: Icons.my_location,
                  onTap: _showCurrentLocation,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LocationBottomSheet(
                  location: state.selectedLocation,
                  isLoading: state.isLoading,
                  onConfirm: _confirmCurrentCenter,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
