import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/domain/entities/forget_password_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/domain/entities/forget_password_response_entity.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/domain/repo/forget_password_repository.dart';

@injectable
class ForgetPasswordUseCase {
  ForgetPasswordUseCase({required this.repository});
  final ForgetPasswordRepository repository;

  Future<ApiResult<ForgetPasswordResponseEntity>> call(
    ForgetPasswordRequestEntity entity,
  ) async {
    return await repository.forgetPassword(entity);
  }
}
