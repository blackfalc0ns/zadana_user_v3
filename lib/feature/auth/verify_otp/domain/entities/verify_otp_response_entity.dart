import 'package:zadana_user_v3/feature/auth/verify_otp/domain/entities/user_model_verify_entity.dart';

/// Verify OTP response entity
/// Domain layer - Pure Dart
class VerifyOtpResponseEntity {
  const VerifyOtpResponseEntity({
    this.user,
    required this.isVerified,
    required this.message,
  });
  final UserModelVerifyEntity? user;
  final bool isVerified;
  final String message;
}
