import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_search_entity.dart';

class LocationState {
  final bool isLoading;
  final bool isSearchLoading;
  final bool isSuccess;
  final String? errorMessage;
  final List<LocationSearchResultEntity> searchResults;
  final LocationEntity? selectedLocation;
  final String query;
  final String addressLine;
  final String city;
  final String area;
  final String buildingNo;
  final String floorNo;
  final String apartmentNo;
  final String label;

  const LocationState({
    this.isLoading = false,
    this.isSearchLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.searchResults = const [],
    this.selectedLocation,
    this.query = '',
    this.addressLine = '',
    this.city = '',
    this.area = '',
    this.buildingNo = '',
    this.floorNo = '',
    this.apartmentNo = '',
    this.label = '',
  });

  LocationState copyWith({
    bool? isLoading,
    bool? isSearchLoading,
    bool? isSuccess,
    String? errorMessage,
    List<LocationSearchResultEntity>? searchResults,
    LocationEntity? selectedLocation,
    String? query,
    String? addressLine,
    String? city,
    String? area,
    String? buildingNo,
    String? floorNo,
    String? apartmentNo,
    String? label,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      searchResults: searchResults ?? this.searchResults,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      query: query ?? this.query,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      area: area ?? this.area,
      buildingNo: buildingNo ?? this.buildingNo,
      floorNo: floorNo ?? this.floorNo,
      apartmentNo: apartmentNo ?? this.apartmentNo,
      label: label ?? this.label,
    );
  }

  bool get isLocationComplete {
    return addressLine.trim().isNotEmpty &&
        city.trim().isNotEmpty &&
        area.trim().isNotEmpty &&
        buildingNo.trim().isNotEmpty &&
        floorNo.trim().isNotEmpty &&
        apartmentNo.trim().isNotEmpty &&
        label.trim().isNotEmpty &&
        selectedLocation != null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationState &&
        other.isLoading == isLoading &&
        other.isSearchLoading == isSearchLoading &&
        other.isSuccess == isSuccess &&
        other.errorMessage == errorMessage &&
        other.searchResults == searchResults &&
        other.selectedLocation == selectedLocation &&
        other.query == query &&
        other.addressLine == addressLine &&
        other.city == city &&
        other.area == area &&
        other.buildingNo == buildingNo &&
        other.floorNo == floorNo &&
        other.apartmentNo == apartmentNo &&
        other.label == label;
  }

  @override
  int get hashCode {
    return Object.hash(
      isLoading,
      isSearchLoading,
      isSuccess,
      errorMessage,
      searchResults,
      selectedLocation,
      query,
      addressLine,
      city,
      area,
      buildingNo,
      floorNo,
      apartmentNo,
      label,
    );
  }
}