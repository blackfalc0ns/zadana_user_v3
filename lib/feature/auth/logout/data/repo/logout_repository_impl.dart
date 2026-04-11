import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/logout/data/data_source/logout_remote_data_source.dart';
import 'package:zadana_user_v3/feature/auth/logout/data/models/request/logout_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/logout/domain/entities/logout_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/logout/domain/repo/logout_repository.dart';

@Injectable(as: LogoutRepository)
class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutRemoteDataSource remoteDataSource;

  LogoutRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResult<void>> logout(LogoutRequestEntity entity) async {
    return safeApiCall<void>(() async {
      final requestDto = LogoutRequestDto(refreshToken: entity.refreshToken);
      await remoteDataSource.logout(requestDto);
    });
  }
}
