import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import '../models/login_request_model_dto.dart';
import '../models/login_response_model_dto.dart';
import 'login_remote_data_source.dart';

/// Login remote data source implementation
/// Data layer - API implementation using Retrofit

@Injectable(as: LoginRemoteDataSource)
class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  LoginRemoteDataSourceImpl(this._apiServices);
  final ApiServices _apiServices;

  @override
  Future<LoginResponseModelDto> login(LoginRequestModelDto request) {
    return _apiServices.login(request);
  }
}
