import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/data/data_source/forget_password_remote_data_source.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/data/models/request/forget_password_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/data/models/response/forget_password_response_dto.dart';

@Injectable(as: ForgetPasswordRemoteDataSource)
class ForgetPasswordRemoteDataSourceImpl
    implements ForgetPasswordRemoteDataSource {
  final ApiServices apiServices;

  ForgetPasswordRemoteDataSourceImpl({
    required this.apiServices,
  });

  @override
  Future<ForgetPasswordResponseDto> forgetPassword(
    ForgetPasswordRequestDto requestDto,
  ) async {
    return await apiServices.forgetPassword(requestDto);
  }
}
