import 'package:zadana_user_v3/core/network/api_results.dart';
import '../entities/profile_response_entity.dart';
import '../entities/update_profile_request_entity.dart';

/// Profile repository contract
/// Domain layer - Abstract interface
abstract class ProfileRepository {
  Future<ApiResult<ProfileResponseEntity>> getProfile();

  Future<ApiResult<ProfileResponseEntity>> updateProfile(
    UpdateProfileRequestEntity request,
  );
}
