import 'package:latlong2/latlong.dart' as ll;
import '../../data/models/location_model.dart';
import '../../data/models/location_search_result.dart';

/// Location cubit state
class LocationState {
  final bool isLoading;
  final bool isLocationSelected;
  final String? selectedAddress;
  final ll.LatLng? selectedCoordinates;
  final LocationModel? locationModel;
  final String? errorMessage;
  final List<LocationSearchResult> searchResults;

  const LocationState({
    this.isLoading = false,
    this.isLocationSelected = false,
    this.selectedAddress,
    this.selectedCoordinates,
    this.locationModel,
    this.errorMessage,
    this.searchResults = const [],
  });

  LocationState copyWith({
    bool? isLoading,
    bool? isLocationSelected,
    String? selectedAddress,
    ll.LatLng? selectedCoordinates,
    LocationModel? locationModel,
    String? errorMessage,
    List<LocationSearchResult>? searchResults,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      isLocationSelected: isLocationSelected ?? this.isLocationSelected,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedCoordinates: selectedCoordinates ?? this.selectedCoordinates,
      locationModel: locationModel ?? this.locationModel,
      errorMessage: errorMessage ?? this.errorMessage,
      searchResults: searchResults ?? this.searchResults,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationState &&
        other.isLoading == isLoading &&
        other.isLocationSelected == isLocationSelected &&
        other.selectedAddress == selectedAddress &&
        other.selectedCoordinates == selectedCoordinates &&
        other.locationModel == locationModel &&
        other.errorMessage == errorMessage &&
        other.searchResults == searchResults;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        isLocationSelected.hashCode ^
        selectedAddress.hashCode ^
        selectedCoordinates.hashCode ^
        locationModel.hashCode ^
        errorMessage.hashCode ^
        searchResults.hashCode;
  }
}
