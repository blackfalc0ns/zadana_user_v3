import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/auth/logout/data/data_source/logout_remote_data_source.dart';
import 'package:zadana_user_v3/feature/auth/logout/data/models/request/logout_request_dto.dart';

@Injectable(as: LogoutRemoteDataSource)
class LogoutRemoteDataSourceImpl implements LogoutRemoteDataSource {
  final ApiServices _apiServices;

  LogoutRemoteDataSourceImpl(this._apiServices);

  @override
  Future<void> logout(LogoutRequestDto requestDto) {
    return _apiServices.logout(requestDto);
  }
}
