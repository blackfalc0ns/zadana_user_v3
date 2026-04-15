import 'package:zadana_user_v3/core/network/api_results.dart';
import '../entities/login_request_entity.dart';
import '../entities/login_response_entity.dart';

/// Login repository contract
/// Domain layer - Abstract interface
abstract class LoginRepository {
  Future<ApiResult<LoginResponseEntity>> login(LoginRequestEntity request);
}
