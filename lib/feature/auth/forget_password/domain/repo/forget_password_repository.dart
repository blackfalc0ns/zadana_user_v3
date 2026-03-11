import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/domain/entities/forget_password_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/domain/entities/forget_password_response_entity.dart';

abstract class ForgetPasswordRepository {
  Future<ApiResult<ForgetPasswordResponseEntity>> forgetPassword(
    ForgetPasswordRequestEntity entity,
  );
}
