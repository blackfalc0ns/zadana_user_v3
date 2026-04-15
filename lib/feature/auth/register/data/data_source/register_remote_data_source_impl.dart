import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/auth/register/data/data_source/register_remote_data_source.dart';
import 'package:zadana_user_v3/feature/auth/register/data/models/request/register_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/register/data/models/response/register_response_dto.dart';

@Injectable(as: RegisterRemoteDataSource)
class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  RegisterRemoteDataSourceImpl({required this.apiServices});
  final ApiServices apiServices;

  @override
  Future<RegisterResponseDto> register(RegisterRequestDto requestDto) async {
    return await apiServices.registerUser(requestDto);
  }
}
