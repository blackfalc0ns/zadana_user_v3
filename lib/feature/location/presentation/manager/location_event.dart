import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_search_entity.dart';

abstract class LocationEvent {
  const LocationEvent();
}

class SearchLocationQueryChangedEvent extends LocationEvent {
  final String query;
  const SearchLocationQueryChangedEvent(this.query);
}

class SearchLocationSubmitEvent extends LocationEvent {
  final String query;
  const SearchLocationSubmitEvent(this.query);
}

class SelectSearchedLocationEvent extends LocationEvent {
  final LocationSearchResultEntity location;
  const SelectSearchedLocationEvent(this.location);
}

class GetCurrentLocationEvent extends LocationEvent {
  const GetCurrentLocationEvent();
}

class GetAddressFromCoordinatesEvent extends LocationEvent {
  final double latitude;
  final double longitude;

  const GetAddressFromCoordinatesEvent({
    required this.latitude,
    required this.longitude,
  });
}

class SetSelectedLocationEvent extends LocationEvent {
  final LocationEntity location;
  const SetSelectedLocationEvent(this.location);
}

class UpdateManualAddressEvent extends LocationEvent {
  final String addressLine;
  const UpdateManualAddressEvent(this.addressLine);
}

class UpdateCityEvent extends LocationEvent {
  final String city;
  const UpdateCityEvent(this.city);
}

class UpdateAreaEvent extends LocationEvent {
  final String area;
  const UpdateAreaEvent(this.area);
}

class UpdateBuildingNoEvent extends LocationEvent {
  final String buildingNo;
  const UpdateBuildingNoEvent(this.buildingNo);
}

class UpdateFloorNoEvent extends LocationEvent {
  final String floorNo;
  const UpdateFloorNoEvent(this.floorNo);
}

class UpdateApartmentNoEvent extends LocationEvent {
  final String apartmentNo;
  const UpdateApartmentNoEvent(this.apartmentNo);
}

class UpdateLabelEvent extends LocationEvent {
  final String label;
  const UpdateLabelEvent(this.label);
}

class ClearLocationErrorEvent extends LocationEvent {
  const ClearLocationErrorEvent();
}

class ClearLocationSuccessEvent extends LocationEvent {
  const ClearLocationSuccessEvent();
}