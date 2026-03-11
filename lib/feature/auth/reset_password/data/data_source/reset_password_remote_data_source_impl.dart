import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/data_source/reset_password_remote_data_source.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/models/request/reset_password_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/models/response/reset_password_response_dto.dart';

@Injectable(as: ResetPasswordRemoteDataSource)
class ResetPasswordRemoteDataSourceImpl
    implements ResetPasswordRemoteDataSource {
  final ApiServices apiServices;

  ResetPasswordRemoteDataSourceImpl({
    required this.apiServices,
  });

  @override
  Future<ResetPasswordResponseDto> resetPassword(
    ResetPasswordRequestDto requestDto,
  ) async {
    return await apiServices.resetPassword(requestDto);
  }
}
