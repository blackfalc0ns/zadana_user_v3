import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_user_v3/core/utils/constants.dart';

@lazySingleton
class PushTokenService {
  PushTokenService(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  Future<void> saveToken(String token) async {
    if (token.trim().isEmpty) return;
    await _sharedPreferences.setString(AppConstants.fcmTokenKey, token);
  }

  String? getToken() {
    final token = _sharedPreferences.getString(AppConstants.fcmTokenKey);
    if (token == null || token.trim().isEmpty) {
      return null;
    }
    return token;
  }

  Future<void> clearToken() async {
    await _sharedPreferences.remove(AppConstants.fcmTokenKey);
  }
}
