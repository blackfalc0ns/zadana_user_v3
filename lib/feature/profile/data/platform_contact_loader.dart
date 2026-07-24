import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/profile/data/models/platform_contact_dto.dart';

/// Public contact data is always fetched when its consumer is opened so
/// dashboard updates are visible on the next visit.
class PlatformContactLoader {
  PlatformContactLoader._();

  static Future<PlatformContactDto> load() =>
      getIt<ApiServices>().getPlatformContact();
}
