import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zadana_user_v3/feature/location/data/models/location_search_dto.dart';
import 'package:zadana_user_v3/feature/location/data/models/reverse_location_dto.dart';

part 'osm_api_services.g.dart';

@RestApi(baseUrl: 'https://nominatim.openstreetmap.org')
@injectable
abstract class OsmApiServices {
  @factoryMethod
  factory OsmApiServices(@Named('osmDio') Dio dio) = _OsmApiServices;

  /// 🔎 Search locations by name
  @GET('/search')
  Future<List<LocationSearchDto>> searchLocations(
    @Query('q') String query,
    @Query('format') String format,
    @Query('accept-language') String language,
    @Query('addressdetails') int addressDetails,
    @Query('limit') int limit,
  );

  /// 📍 Reverse geocoding (lat/lon → address)
  @GET('/reverse')
  Future<ReverseLocationDto> reverseGeocode(
    @Query('lat') double latitude,
    @Query('lon') double longitude,
    @Query('format') String format,
    @Query('accept-language') String language,
  );
}
