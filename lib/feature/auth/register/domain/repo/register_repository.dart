import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_response_entity.dart';

abstract class RegisterRepository {
  Future<ApiResult<RegisterResponseEntity>> register(
    RegisterEntity entity,
  );
}
