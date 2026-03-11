import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/reset_password_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/reset_password_response_entity.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/repo/reset_password_repository.dart';

@injectable
class ResetPasswordUseCase {
  final ResetPasswordRepository repository;

  ResetPasswordUseCase({required this.repository});

  Future<ApiResult<ResetPasswordResponseEntity>> call(
    ResetPasswordRequestEntity entity,
  ) async {
    return await repository.resetPassword(entity);
  }
}
