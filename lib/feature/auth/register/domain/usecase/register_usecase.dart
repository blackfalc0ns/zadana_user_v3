import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_response_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/repo/register_repository.dart';

@injectable
class RegisterUseCase {
  RegisterUseCase({required this.repository});
  final RegisterRepository repository;

  Future<ApiResult<RegisterResponseEntity>> call(
    RegisterRequestEntity entity,
  ) async {
    return await repository.register(entity);
  }
}
