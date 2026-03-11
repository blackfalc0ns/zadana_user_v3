import '../models/login_request_model_dto.dart';
import '../models/login_response_model_dto.dart';

/// Login remote data source contract
/// Data layer - API interface
abstract class LoginRemoteDataSource {
  Future<LoginResponseModelDto> login(LoginRequestModelDto request);
}