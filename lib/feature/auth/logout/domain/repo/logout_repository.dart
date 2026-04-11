import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/logout/domain/entities/logout_request_entity.dart';

abstract class LogoutRepository {
  Future<ApiResult<void>> logout(LogoutRequestEntity entity);
}
