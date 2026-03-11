import '../models/profile_response_model_dto.dart';

/// Profile remote data source contract
/// Data layer - API interface
abstract class ProfileRemoteDataSource {
  Future<ProfileResponseModelDto> getProfile();
}
