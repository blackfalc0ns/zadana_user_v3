import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import '../models/verify_otp_request_model_dto.dart';
import '../models/verify_otp_response_model_dto.dart';
import 'verify_otp_remote_data_source.dart';

/// Verify OTP remote data source implementation
/// Data layer - API implementation using Retrofit
@Injectable(as: VerifyOtpRemoteDataSource)
class VerifyOtpRemoteDataSourceImpl implements VerifyOtpRemoteDataSource {
  VerifyOtpRemoteDataSourceImpl(this._apiServices);
  final ApiServices _apiServices;

  @override
  Future<VerifyOtpResponseModelDto> verifyOtp(
    VerifyOtpRequestModelDto request,
  ) {
    return _apiServices.verifyOtp(request);
  }
}
