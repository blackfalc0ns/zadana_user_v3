import 'package:bloc/bloc.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../../data/repositories/location_repository.dart';
import 'location_state.dart';

/// Location cubit for handling location selection
class LocationCubit extends Cubit<LocationState> {
  final LocationRepository _repository;

  LocationCubit({required LocationRepository repository})
    : _repository = repository,
      super(const LocationState());

  /// Get address from coordinates
  Future<void> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getAddressFromCoordinates(
      latitude,
      longitude,
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (address) => emit(
        state.copyWith(
          isLoading: false,
          selectedAddress: address,
          selectedCoordinates: ll.LatLng(latitude, longitude),
        ),
      ),
    );
  }

  /// Get address from LatLng
  Future<void> getAddressFromLatLng(ll.LatLng coordinates) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getAddressFromLatLng(coordinates);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (address) => emit(
        state.copyWith(
          isLoading: false,
          selectedAddress: address,
          selectedCoordinates: coordinates,
        ),
      ),
    );
  }

  /// Create and select location model
  Future<void> selectLocation(double latitude, double longitude) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.createLocationModel(
      latitude: latitude,
      longitude: longitude,
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (locationModel) => emit(
        state.copyWith(
          isLoading: false,
          isLocationSelected: true,
          locationModel: locationModel,
          selectedAddress: locationModel.address,
          selectedCoordinates: locationModel.coordinates,
        ),
      ),
    );
  }

  /// Clear selected location
  void clearLocation() {
    emit(
      state.copyWith(
        isLocationSelected: false,
        locationModel: null,
        selectedAddress: null,
        selectedCoordinates: null,
        errorMessage: null,
      ),
    );
  }

  /// Clear error message
  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  /// Update coordinates without fetching address
  void updateCoordinates(ll.LatLng coordinates) {
    emit(state.copyWith(selectedCoordinates: coordinates));
  }

  /// Search locations by query
  Future<void> searchLocations(String query) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(searchResults: []));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.searchLocations(query);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (results) =>
          emit(state.copyWith(isLoading: false, searchResults: results)),
    );
  }

  /// Clear search results
  void clearSearchResults() {
    emit(state.copyWith(searchResults: []));
  }
}
