import 'package:package_info_plus/package_info_plus.dart';

class AppPackageInfo {
  AppPackageInfo._();

  static Future<PackageInfo>? _packageInfoFuture;

  static Future<PackageInfo> get packageInfo =>
      _packageInfoFuture ??= PackageInfo.fromPlatform();

  static Future<String> get versionName async {
    final info = await packageInfo;
    final buildNumber = info.buildNumber.trim();
    if (buildNumber.isEmpty) {
      return info.version.trim();
    }
    return '${info.version.trim()}+$buildNumber';
  }
}
