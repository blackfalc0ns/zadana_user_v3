import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/core/services/language_service.dart';
import 'package:zadana_user_v3/core/services/saved_location_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/add_customer_address_request_dto.dart';
import 'package:zadana_user_v3/feature/addresses/domain/usecase/add_customer_address_usecase.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/domain/usecase/get_address_from_coordinates_use_case.dart';
import 'package:zadana_user_v3/feature/location/domain/usecase/get_current_location_with_address_use_case.dart';
import 'package:zadana_user_v3/feature/location/domain/usecase/search_locations_usecase.dart';
import 'package:zadana_user_v3/feature/location/location_failure_codes.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_state.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';
import 'package:zadana_user_v3/feature/profile/domain/usecase/profile_usecase.dart';

@injectable
class LocationViewModel extends Cubit<LocationState> {
  LocationViewModel(
    this._searchLocationsUseCase,
    this._getCurrentLocationWithAddressUseCase,
    this._getAddressFromCoordinatesUseCase,
    this._addCustomerAddressUseCase,
    this._profileUseCase,
    this._tokenService,
  ) : super(const LocationState());

  final SearchLocationsUseCase _searchLocationsUseCase;
  final GetCurrentLocationWithAddressUseCase
      _getCurrentLocationWithAddressUseCase;
  final GetAddressFromCoordinatesUseCase _getAddressFromCoordinatesUseCase;
  final AddCustomerAddressUseCase _addCustomerAddressUseCase;
  final ProfileUseCase _profileUseCase;
  final TokenService _tokenService;

  double? _lastReverseLat;
  double? _lastReverseLon;
  Timer? _debounce;
  DateTime? _lastApiCall;

  static const Duration _minApiInterval = Duration(seconds: 2);

  AppLocalizations get _l10n {
    final languageCode = getIt<LanguageService>().getLanguageCode();
    return lookupAppLocalizations(Locale(languageCode));
  }

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
      case SaveSelectedAddressEvent():
        _saveSelectedAddress(event);
      case UpdateManualAddressEvent():
        emit(
          state.copyWith(
            addressLine: event.addressLine,
            isAddressSaved: false,
            errorMessage: null,
            failure: null,
          ),
        );
      case UpdateCityEvent():
        emit(
          state.copyWith(
            city: event.city,
            isAddressSaved: false,
            errorMessage: null,
            failure: null,
          ),
        );
      case UpdateAreaEvent():
        emit(
          state.copyWith(
            area: event.area,
            isAddressSaved: false,
            errorMessage: null,
            failure: null,
          ),
        );
      case UpdateBuildingNoEvent():
        emit(
          state.copyWith(
            buildingNo: event.buildingNo,
            isAddressSaved: false,
            errorMessage: null,
            failure: null,
          ),
        );
      case UpdateFloorNoEvent():
        emit(
          state.copyWith(
            floorNo: event.floorNo,
            isAddressSaved: false,
            errorMessage: null,
            failure: null,
          ),
        );
      case UpdateApartmentNoEvent():
        emit(
          state.copyWith(
            apartmentNo: event.apartmentNo,
            isAddressSaved: false,
            errorMessage: null,
            failure: null,
          ),
        );
      case UpdateLabelEvent():
        emit(
          state.copyWith(
            label: event.label,
            isAddressSaved: false,
            errorMessage: null,
            failure: null,
          ),
        );
      case ClearLocationErrorEvent():
        emit(
          state.copyWith(
            errorMessage: null,
            failure: null,
            isAddressSaved: false,
          ),
        );
      case ClearLocationSuccessEvent():
        emit(
          state.copyWith(
            isSuccess: false,
            isAddressSaved: false,
          ),
        );
    }
  }

  void _onSearchQueryChanged(SearchLocationQueryChangedEvent event) {
    emit(
      state.copyWith(
        query: event.query,
        isAddressSaved: false,
        errorMessage: null,
        failure: null,
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
        isAddressSaved: false,
        errorMessage: null,
        failure: null,
      ),
    );

    developer.log('Searching locations: $query', name: 'LocationViewModel');

    final result = await _searchLocationsUseCase.call(query);
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isSearchLoading: false,
            searchResults: result.data,
            failure: null,
          ),
        );
      case ApiErrorResult():
        if (_isRateLimited(result.failure)) {
          final message = _l10n.location_search_temporarily_unavailable;
          emit(
            state.copyWith(
              isSearchLoading: false,
              errorMessage: message,
              failure: Failure(
                errorMessage: message,
                code: LocationFailureCodes.searchTemporarilyUnavailable,
              ),
              searchResults: const [],
            ),
          );
        } else {
          emit(
            state.copyWith(
              isSearchLoading: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
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
        isAddressSaved: false,
        errorMessage: null,
        failure: null,
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
        isAddressSaved: false,
        errorMessage: null,
        failure: null,
      ),
    );

    developer.log('Getting current location', name: 'LocationViewModel');

    final result = await _getCurrentLocationWithAddressUseCase.call();
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            isAddressSaved: false,
            selectedLocation: result.data,
            addressLine: result.data.addressLine,
            city: result.data.city,
            area: result.data.area,
            failure: null,
          ),
        );
      case ApiErrorResult():
        final failure = _mapCurrentLocationFailure(result.failure);
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: failure.errorMessage,
            failure: failure,
          ),
        );
    }
  }

  Future<void> _getAddressFromCoordinates(
    GetAddressFromCoordinatesEvent event,
  ) async {
    final now = DateTime.now();
    if (_lastApiCall != null &&
        now.difference(_lastApiCall!) < _minApiInterval) {
      developer.log(
        'API call skipped due to rate limiting',
        name: 'LocationViewModel',
      );
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
        isAddressSaved: false,
        errorMessage: null,
        failure: null,
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
            isAddressSaved: false,
            selectedLocation: result.data,
            addressLine: result.data.addressLine,
            city: result.data.city,
            area: result.data.area,
            failure: null,
          ),
        );
      case ApiErrorResult():
        if (_isRateLimited(result.failure)) {
          developer.log('Rate limited - backing off', name: 'LocationViewModel');
          final message = _l10n.location_rate_limit_retry;
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: message,
              failure: Failure(
                errorMessage: message,
                code: LocationFailureCodes.rateLimitRetry,
              ),
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
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
        buildingNo: event.location.buildingNo,
        floorNo: event.location.floorNo,
        apartmentNo: event.location.apartmentNo,
        label: event.location.label,
        errorMessage: null,
        failure: null,
        isSuccess: true,
        isAddressSaved: false,
      ),
    );
  }

  Future<void> _saveSelectedAddress(SaveSelectedAddressEvent event) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        isAddressSaved: false,
        selectedLocation: event.location,
        addressLine: event.location.addressLine,
        city: event.location.city,
        area: event.location.area,
        buildingNo: event.location.buildingNo,
        floorNo: event.location.floorNo,
        apartmentNo: event.location.apartmentNo,
        label: event.location.label,
        errorMessage: null,
        failure: null,
      ),
    );

    await SavedLocationService.saveLocation(event.location);

    final token = await _tokenService.getToken();
    if (token == null || token.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          isAddressSaved: true,
          errorMessage: null,
          failure: null,
        ),
      );
      return;
    }

    final profileResult = await _profileUseCase.call();
    if (isClosed) return;

    switch (profileResult) {
      case ApiSuccessResult<ProfileResponseEntity>():
        final request = AddCustomerAddressRequestDto(
          contactName: profileResult.data.fullName.trim(),
          contactPhone: profileResult.data.phone.trim(),
          addressLine: event.location.addressLine.trim(),
          label: event.location.label.trim().isEmpty
              ? 'Home'
              : event.location.label.trim(),
          buildingNo: _nullIfEmpty(event.location.buildingNo),
          floorNo: event.location.floorNo.trim(),
          apartmentNo: event.location.apartmentNo.trim(),
          city: event.location.city.trim(),
          area: _nullIfEmpty(event.location.area),
          latitude: event.location.latitude,
          longitude: event.location.longitude,
          isDefault: true,
        );

        final saveResult = await _addCustomerAddressUseCase.call(request);
        if (isClosed) return;

        switch (saveResult) {
          case ApiSuccessResult():
            emit(
              state.copyWith(
                isLoading: false,
                isAddressSaved: true,
                errorMessage: null,
                failure: null,
              ),
            );
          case ApiErrorResult():
            emit(
              state.copyWith(
                isLoading: false,
                isAddressSaved: false,
                errorMessage: saveResult.failure.errorMessage,
                failure: saveResult.failure,
              ),
            );
        }
      case ApiErrorResult<ProfileResponseEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            isAddressSaved: false,
            errorMessage: profileResult.failure.errorMessage,
            failure: profileResult.failure,
          ),
        );
    }
  }

  bool _isRateLimited(Failure failure) {
    return failure.code == 'error_unknown' &&
        (failure.errorMessage.contains('429') ||
            failure.errorMessage.contains('Too many requests'));
  }

  Failure _mapCurrentLocationFailure(Failure failure) {
    final message = failure.errorMessage.toLowerCase();

    if (message.contains('service') && message.contains('disabled')) {
      final localizedMessage = _l10n.location_service_disabled_message;
      return Failure(
        errorMessage: localizedMessage,
        code: LocationFailureCodes.serviceDisabled,
      );
    }

    if (message.contains('denied forever') ||
        message.contains('permanently denied')) {
      final localizedMessage = _l10n.location_permission_denied_forever_message;
      return Failure(
        errorMessage: localizedMessage,
        code: LocationFailureCodes.permissionDeniedForever,
      );
    }

    if (message.contains('permission denied') ||
        message.contains('denied')) {
      final localizedMessage = _l10n.location_permission_denied_message;
      return Failure(
        errorMessage: localizedMessage,
        code: LocationFailureCodes.permissionDenied,
      );
    }

    return failure;
  }

  String? _nullIfEmpty(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void clearFeedback() {
    emit(
      state.copyWith(
        errorMessage: null,
        failure: null,
        isSuccess: false,
        isAddressSaved: false,
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
