import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/domain/usecase/get_address_from_coordinates_use_case.dart';
import 'package:zadana_user_v3/feature/location/domain/usecase/get_current_location_with_address_use_case.dart';
import 'package:zadana_user_v3/feature/location/domain/usecase/search_locations_usecase.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_state.dart';

@injectable
class LocationViewModel extends Cubit<LocationState> {
  LocationViewModel(
    this._searchLocationsUseCase,
    this._getCurrentLocationWithAddressUseCase,
    this._getAddressFromCoordinatesUseCase,
  ) : super(const LocationState());

  final SearchLocationsUseCase _searchLocationsUseCase;
  final GetCurrentLocationWithAddressUseCase
      _getCurrentLocationWithAddressUseCase;
  final GetAddressFromCoordinatesUseCase _getAddressFromCoordinatesUseCase;
  double? _lastReverseLat;
  double? _lastReverseLon;
  Timer? _debounce;
  
  // Rate limiting
  DateTime? _lastApiCall;
  static const Duration _minApiInterval = Duration(seconds: 2);

  void doIntent(LocationEvent event) {
    switch (event) {
      case SearchLocationQueryChangedEvent():
        _onSearchQueryChanged(event);

      case SearchLocationSubmitEvent():
        _searchLocations(event);

      case SelectSearchedLocationEvent():
        _selectSearchedLocation(event);

      case GetCurrentLocationEvent():
        _getCurrentLocation();

      case GetAddressFromCoordinatesEvent():
        _getAddressFromCoordinates(event);

      case SetSelectedLocationEvent():
        _setSelectedLocation(event);

      case UpdateManualAddressEvent():
        emit(
          state.copyWith(
            addressLine: event.addressLine,
            errorMessage: null,
          ),
        );

      case UpdateCityEvent():
        emit(
          state.copyWith(
            city: event.city,
            errorMessage: null,
          ),
        );

      case UpdateAreaEvent():
        emit(
          state.copyWith(
            area: event.area,
            errorMessage: null,
          ),
        );

      case UpdateBuildingNoEvent():
        emit(
          state.copyWith(
            buildingNo: event.buildingNo,
            errorMessage: null,
          ),
        );

      case UpdateFloorNoEvent():
        emit(
          state.copyWith(
            floorNo: event.floorNo,
            errorMessage: null,
          ),
        );

      case UpdateApartmentNoEvent():
        emit(
          state.copyWith(
            apartmentNo: event.apartmentNo,
            errorMessage: null,
          ),
        );

      case UpdateLabelEvent():
        emit(
          state.copyWith(
            label: event.label,
            errorMessage: null,
          ),
        );

      case ClearLocationErrorEvent():
        emit(
          state.copyWith(
            errorMessage: null,
          ),
        );

      case ClearLocationSuccessEvent():
        emit(
          state.copyWith(
            isSuccess: false,
          ),
        );
    }
  }

  void _onSearchQueryChanged(SearchLocationQueryChangedEvent event) {
    emit(
      state.copyWith(
        query: event.query,
        errorMessage: null,
      ),
    );

    _debounce?.cancel();

    final query = event.query.trim();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchResults: const [],
          isSearchLoading: false,
        ),
      );
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 1000), () {
      doIntent(SearchLocationSubmitEvent(query));
    });
  }

  Future<void> _searchLocations(SearchLocationSubmitEvent event) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchResults: const [],
          isSearchLoading: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSearchLoading: true,
        errorMessage: null,
      ),
    );

    developer.log(
      'Searching locations: $query',
      name: 'LocationViewModel',
    );

    final result = await _searchLocationsUseCase.call(query);

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isSearchLoading: false,
            searchResults: result.data,
          ),
        );

      case ApiErrorResult():
        // Handle rate limiting for search
        if (result.failure.code == 'error_unknown' &&
            (result.failure.errorMessage.contains('429') ||
             result.failure.errorMessage.contains('Too many requests'))) {
          emit(
            state.copyWith(
              isSearchLoading: false,
              errorMessage: 'البحث مؤقتاً غير متاح، يرجى المحاولة لاحقاً',
              searchResults: const [],
            ),
          );
        } else {
          emit(
            state.copyWith(
              isSearchLoading: false,
              errorMessage: result.failure.code,
            ),
          );
        }
    }
  }

  void _selectSearchedLocation(SelectSearchedLocationEvent event) {
    emit(
      state.copyWith(
        query: event.location.addressLine,
        searchResults: const [],
        errorMessage: null,
      ),
    );

    doIntent(
      GetAddressFromCoordinatesEvent(
        latitude: event.location.latitude,
        longitude: event.location.longitude,
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );

    developer.log(
      'Getting current location',
      name: 'LocationViewModel',
    );

    final result = await _getCurrentLocationWithAddressUseCase.call();

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            selectedLocation: result.data,
            addressLine: result.data.addressLine,
            city: result.data.city,
            area: result.data.area,
          ),
        );

      case ApiErrorResult():
        String errorMessage = result.failure.errorMessage;
        
        // Handle specific location permission errors
        if (errorMessage.contains('خدمة الموقع غير مفعلة')) {
          errorMessage = 'خدمة الموقع غير مفعلة. يرجى تفعيل خدمة الموقع من الإعدادات ثم المحاولة مرة أخرى.';
        } else if (errorMessage.contains('تم رفض إذن الوصول للموقع نهائياً')) {
          errorMessage = 'تم رفض إذن الوصول للموقع نهائياً. يرجى الذهاب لإعدادات التطبيق وتفعيل إذن الموقع.';
        } else if (errorMessage.contains('تم رفض إذن الوصول للموقع')) {
          errorMessage = 'يحتاج التطبيق إذن الوصول للموقع لتحديد موقعك الحالي. يرجى السماح بالوصول للموقع.';
        }
        
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: errorMessage,
          ),
        );
    }
  }

  Future<void> _getAddressFromCoordinates(
  GetAddressFromCoordinatesEvent event,
) async {
  // Rate limiting check
  final now = DateTime.now();
  if (_lastApiCall != null && 
      now.difference(_lastApiCall!) < _minApiInterval) {
    developer.log('API call skipped due to rate limiting', name: 'LocationViewModel');
    return;
  }

  final lastLat = _lastReverseLat;
  final lastLon = _lastReverseLon;

  if (lastLat != null && lastLon != null) {
    final latDiff = (event.latitude - lastLat).abs();
    final lonDiff = (event.longitude - lastLon).abs();

    if (latDiff < 0.002 && lonDiff < 0.002) {
      return;
    }
  }

  _lastReverseLat = event.latitude;
  _lastReverseLon = event.longitude;
  _lastApiCall = now;

  emit(
    state.copyWith(
      isLoading: true,
      errorMessage: null,
    ),
  );

  developer.log(
    'Getting address for: ${event.latitude}, ${event.longitude}',
    name: 'LocationViewModel',
  );

  final result = await _getAddressFromCoordinatesUseCase.call(
    event.latitude,
    event.longitude,
  );

  if (isClosed) return;

  switch (result) {
    case ApiSuccessResult():
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          selectedLocation: result.data,
          addressLine: result.data.addressLine,
          city: result.data.city,
          area: result.data.area,
        ),
      );

    case ApiErrorResult():
      // Handle rate limiting error specifically
      if (result.failure.code == 'error_unknown' &&
          (result.failure.errorMessage.contains('429') ||
           result.failure.errorMessage.contains('Too many requests'))) {
        developer.log('Rate limited - backing off', name: 'LocationViewModel');
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'يرجى الانتظار قليلاً قبل المحاولة مرة أخرى',
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.failure.code,
          ),
        );
      }
  }
}
  void _setSelectedLocation(SetSelectedLocationEvent event) {
    emit(
      state.copyWith(
        selectedLocation: event.location,
        addressLine: event.location.addressLine,
        city: event.location.city,
        area: event.location.area,
        errorMessage: null,
        isSuccess: true,
      ),
    );
  }

  LocationEntity? get selectedLocationData {
    final location = state.selectedLocation;
    if (location == null) return null;

    return LocationEntity(
      addressLine: state.addressLine,
      city: state.city,
      area: state.area,
      latitude: location.latitude,
      longitude: location.longitude,
      buildingNo: state.buildingNo,
      floorNo: state.floorNo,
      apartmentNo: state.apartmentNo,
      label: state.label,
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}