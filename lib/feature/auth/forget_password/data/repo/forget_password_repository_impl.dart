import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/data/data_source/forget_password_remote_data_source.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/data/mapper/forget_password_mapper.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/domain/entities/forget_password_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/domain/entities/forget_password_response_entity.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/domain/repo/forget_password_repository.dart';

@Injectable(as: ForgetPasswordRepository)
class ForgetPasswordRepositoryImpl implements ForgetPasswordRepository {
  final ForgetPasswordRemoteDataSource remoteDataSource;

  ForgetPasswordRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResult<ForgetPasswordResponseEntity>> forgetPassword(
    ForgetPasswordRequestEntity entity,
  ) async {
    return await safeApiCall<ForgetPasswordResponseEntity>(() async {
      final requestDto = ForgetPasswordMapper.toDto(entity);
      final responseDto = await remoteDataSource.forgetPassword(requestDto);
      return ForgetPasswordMapper.toEntity(responseDto);
    });
  }
}
