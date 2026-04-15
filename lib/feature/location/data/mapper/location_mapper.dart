import 'package:zadana_user_v3/feature/location/data/models/location_search_dto.dart';
import 'package:zadana_user_v3/feature/location/data/models/reverse_location_dto.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_search_entity.dart';

class LocationMapper {
  static LocationSearchResultEntity searchDtoToEntity(LocationSearchDto dto) {
    return LocationSearchResultEntity(
      placeId: dto.placeId,
      addressLine: dto.displayName ?? "",
      latitude: double.tryParse(dto.lat ?? "") ?? 0.0,
      longitude: double.tryParse(dto.lon ?? "") ?? 0.0,
    );
  }

  static List<LocationSearchResultEntity> searchListToEntity(
    List<LocationSearchDto> dtos,
  ) {
    return dtos.map(searchDtoToEntity).toList();
  }

  static LocationEntity reverseDtoToEntity(
    ReverseLocationDto dto, {
    double? fallbackLatitude,
    double? fallbackLongitude,
  }) {
    final city =
        dto.address?.city ?? dto.address?.town ?? dto.address?.village ?? '';

    final area =
        dto.address?.suburb ?? dto.address?.county ?? dto.address?.state ?? '';

    return LocationEntity(
      addressLine: dto.displayName ?? '',
      city: city,
      area: area,
      latitude: double.tryParse(dto.lat ?? '') ?? fallbackLatitude ?? 0.0,
      longitude: double.tryParse(dto.lon ?? '') ?? fallbackLongitude ?? 0.0,
    );
  }
}
