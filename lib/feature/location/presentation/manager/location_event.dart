import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_search_entity.dart';

abstract class LocationEvent {
  const LocationEvent();
}

class SearchLocationQueryChangedEvent extends LocationEvent {
  const SearchLocationQueryChangedEvent(this.query);
  final String query;
}

class SearchLocationSubmitEvent extends LocationEvent {
  const SearchLocationSubmitEvent(this.query);
  final String query;
}

class SelectSearchedLocationEvent extends LocationEvent {
  const SelectSearchedLocationEvent(this.location);
  final LocationSearchResultEntity location;
}

class GetCurrentLocationEvent extends LocationEvent {
  const GetCurrentLocationEvent();
}

class GetAddressFromCoordinatesEvent extends LocationEvent {
  const GetAddressFromCoordinatesEvent({
    required this.latitude,
    required this.longitude,
  });
  final double latitude;
  final double longitude;
}

class SetSelectedLocationEvent extends LocationEvent {
  const SetSelectedLocationEvent(this.location);
  final LocationEntity location;
}

class SaveSelectedAddressEvent extends LocationEvent {
  const SaveSelectedAddressEvent(this.location);
  final LocationEntity location;
}

class UpdateManualAddressEvent extends LocationEvent {
  const UpdateManualAddressEvent(this.addressLine);
  final String addressLine;
}

class UpdateCityEvent extends LocationEvent {
  const UpdateCityEvent(this.city);
  final String city;
}

class UpdateAreaEvent extends LocationEvent {
  const UpdateAreaEvent(this.area);
  final String area;
}

class UpdateBuildingNoEvent extends LocationEvent {
  const UpdateBuildingNoEvent(this.buildingNo);
  final String buildingNo;
}

class UpdateFloorNoEvent extends LocationEvent {
  const UpdateFloorNoEvent(this.floorNo);
  final String floorNo;
}

class UpdateApartmentNoEvent extends LocationEvent {
  const UpdateApartmentNoEvent(this.apartmentNo);
  final String apartmentNo;
}

class UpdateLabelEvent extends LocationEvent {
  const UpdateLabelEvent(this.label);
  final String label;
}

class ClearLocationErrorEvent extends LocationEvent {
  const ClearLocationErrorEvent();
}

class ClearLocationSuccessEvent extends LocationEvent {
  const ClearLocationSuccessEvent();
}
