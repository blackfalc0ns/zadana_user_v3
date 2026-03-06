import 'package:zadana_user_v3/feature/auth/register/data/models/response/register_response_dto.dart';
import 'package:zadana_user_v3/feature/auth/register/data/models/request/register_request_dto.dart';

abstract class RegisterRemoteDataSource {
  Future<RegisterResponseDto> register(
    RegisterRequestDto requestDto,
  );
}
