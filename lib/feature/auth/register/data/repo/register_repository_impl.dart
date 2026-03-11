import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/register/data/data_source/register_remote_data_source.dart';
import 'package:zadana_user_v3/feature/auth/register/data/mapper/register_mapper.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_response_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/repo/register_repository.dart';

@Injectable(as: RegisterRepository)
class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;

  RegisterRepositoryImpl( this.remoteDataSource);

  @override
  Future<ApiResult<RegisterResponseEntity>> register(
    RegisterRequestEntity entity,
  ) async {
    return await safeApiCall<RegisterResponseEntity>(() async {
      final requestDto = RegisterMapper.toDto(entity);
      final responseDto = await remoteDataSource.register(requestDto);

      return RegisterMapper.toEntity(responseDto);
    });
  }
}
