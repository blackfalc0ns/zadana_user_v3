import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../../domain/repo/delivery_verification_repo.dart';
import '../data_source/delivery_verification_remote_data_source.dart';
import '../models/delivery_otp_request_model.dart';

/// Delivery Verification repository implementation
/// Data layer - Repository implementation
@Injectable(as: DeliveryVerificationRepo)
class DeliveryVerificationRepoImpl implements DeliveryVerificationRepo {
  const DeliveryVerificationRepoImpl(this._remoteDataSource);
  final DeliveryVerificationRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<void>> sendOtp(String orderId, String phoneNumber) async {
    return safeApiCall(() async {
      final request = DeliveryOtpRequestModel(
        orderId: orderId,
        otpCode: '', // Empty for send
      );
      await _remoteDataSource.sendOtp(request);
    });
  }

  @override
  Future<ApiResult<bool>> verifyOtp(String orderId, String otpCode) async {
    return safeApiCall(() async {
      final request = DeliveryOtpRequestModel(
        orderId: orderId,
        otpCode: otpCode,
      );
      final response = await _remoteDataSource.verifyOtp(request);
      return response.success;
    });
  }

  @override
  Future<ApiResult<void>> resendOtp(String orderId) async {
    return safeApiCall(() async {
      final request = DeliveryOtpRequestModel(
        orderId: orderId,
        otpCode: '', // Empty for resend
      );
      await _remoteDataSource.resendOtp(request);
    });
  }
}
