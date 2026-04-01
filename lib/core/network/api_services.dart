import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/data/models/request/forget_password_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/data/models/response/forget_password_response_dto.dart';
import 'package:zadana_user_v3/feature/auth/login/data/models/login_request_model_dto.dart';
import 'package:zadana_user_v3/feature/auth/login/data/models/login_response_model_dto.dart';
import 'package:zadana_user_v3/feature/auth/register/data/models/request/register_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/register/data/models/response/register_response_dto.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/models/request/reset_password_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/models/response/reset_password_response_dto.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/data/models/verify_otp_request_model_dto.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/data/models/verify_otp_response_model_dto.dart';
import 'package:zadana_user_v3/feature/profile/data/models/profile_response_model_dto.dart';
import 'package:zadana_user_v3/feature/location/data/models/location_search_dto.dart';
import 'package:zadana_user_v3/feature/delivery_verification/data/models/delivery_otp_request_model.dart';
import 'package:zadana_user_v3/feature/delivery_verification/data/models/delivery_otp_response_model.dart';
part 'api_services.g.dart';

@RestApi()
@injectable
abstract class ApiServices {
  @factoryMethod
  factory ApiServices(Dio dio) = _ApiServices;

  @POST(EndPoints.register)
  Future<RegisterResponseDto> registerUser(
    @Body() RegisterRequestDto requestDto,
  );

   @POST(EndPoints.login)
  Future<LoginResponseModelDto> login(
    @Body() LoginRequestModelDto request,
  );

  @POST(EndPoints.forgetPassword)
  Future<ForgetPasswordResponseDto> forgetPassword(
    @Body() ForgetPasswordRequestDto request,
  );

  @POST(EndPoints.resetPassword)
  Future<ResetPasswordResponseDto> resetPassword(
    @Body() ResetPasswordRequestDto request,
  );

  @POST(EndPoints.verifyOtp)
  Future<VerifyOtpResponseModelDto> verifyOtp(
    @Body() VerifyOtpRequestModelDto request,
  );

  @GET(EndPoints.getProfile)
  Future<ProfileResponseModelDto> getProfile();

  @GET(EndPoints.searchLocations)
  Future<List<LocationSearchDto>> searchLocations(
    @Query('query') String query,
  );

  @POST(EndPoints.sendDeliveryOtp)
  Future<void> sendDeliveryOtp(
    @Body() DeliveryOtpRequestModel request,
  );

  @POST(EndPoints.verifyDeliveryOtp)
  Future<DeliveryOtpResponseModel> verifyDeliveryOtp(
    @Body() DeliveryOtpRequestModel request,
  );

  @POST(EndPoints.resendDeliveryOtp)
  Future<void> resendDeliveryOtp(
    @Body() DeliveryOtpRequestModel request,
  );
}
