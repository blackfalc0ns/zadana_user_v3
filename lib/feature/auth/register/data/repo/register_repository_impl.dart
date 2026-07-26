import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/auth/register/data/data_source/register_remote_data_source.dart';
import 'package:zadana_user_v3/feature/auth/register/data/mapper/register_mapper.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_response_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/repo/register_repository.dart';

@Injectable(as: RegisterRepository)
class RegisterRepositoryImpl implements RegisterRepository {
  RegisterRepositoryImpl(this.remoteDataSource, this._tokenService);
  final RegisterRemoteDataSource remoteDataSource;
  final TokenService _tokenService;

  @override
  Future<ApiResult<RegisterResponseEntity>> register(
    RegisterRequestEntity entity,
  ) async {
    return await safeApiCall<RegisterResponseEntity>(() async {
      final requestDto = RegisterMapper.toDto(entity);
      final responseDto = await remoteDataSource.register(requestDto);

      // A registration is not an authenticated session. Keep only the
      // short-lived registration JWT until OTP verification succeeds.
      if (responseDto.registrationToken == null ||
          responseDto.registrationToken!.trim().isEmpty) {
        throw StateError(
          'Registration session was not returned by the server.',
        );
      }
      await _tokenService.saveRegistrationToken(responseDto.registrationToken);

      return RegisterMapper.toEntity(responseDto);
    });
  }
}
