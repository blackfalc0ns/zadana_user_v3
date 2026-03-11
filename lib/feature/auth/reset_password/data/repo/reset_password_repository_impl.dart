import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/data_source/reset_password_remote_data_source.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/mapper/reset_password_mapper.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/reset_password_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/reset_password_response_entity.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/repo/reset_password_repository.dart';

@Injectable(as: ResetPasswordRepository)
class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  final ResetPasswordRemoteDataSource remoteDataSource;

  ResetPasswordRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResult<ResetPasswordResponseEntity>> resetPassword(
    ResetPasswordRequestEntity entity,
  ) async {
    return await safeApiCall<ResetPasswordResponseEntity>(() async {
      final requestDto = ResetPasswordMapper.toDto(entity);
      final responseDto = await remoteDataSource.resetPassword(requestDto);
      return ResetPasswordMapper.toEntity(responseDto);
    });
  }
}
