import 'package:zadana_user_v3/feature/auth/logout/data/models/request/logout_request_dto.dart';

abstract class LogoutRemoteDataSource {
  Future<void> logout(LogoutRequestDto requestDto);
}
