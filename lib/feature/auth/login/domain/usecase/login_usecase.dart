import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../entities/login_request_entity.dart';
import '../entities/login_response_entity.dart';
import '../repo/login_repository.dart';

/// Login use case
/// Domain layer - Business logic
@injectable
class LoginUseCase {
  final LoginRepository _repository;

  const LoginUseCase(this._repository);

  Future<ApiResult<LoginResponseEntity>> call(
    LoginRequestEntity request,
  ) async {
    return await _repository.login(request);
  }
}