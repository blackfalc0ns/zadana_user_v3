import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/logout/domain/entities/logout_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/logout/domain/repo/logout_repository.dart';

@injectable
class LogoutUseCase {
  final LogoutRepository repository;

  LogoutUseCase({required this.repository});

  Future<ApiResult<void>> call(LogoutRequestEntity entity) async {
    return repository.logout(entity);
  }
}
