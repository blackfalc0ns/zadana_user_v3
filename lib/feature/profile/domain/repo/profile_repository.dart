import 'package:zadana_user_v3/core/network/api_results.dart';
import '../entities/profile_response_entity.dart';

/// Profile repository contract
/// Domain layer - Abstract interface
abstract class ProfileRepository {
  Future<ApiResult<ProfileResponseEntity>> getProfile();
}
