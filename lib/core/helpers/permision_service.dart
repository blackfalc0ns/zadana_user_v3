import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@injectable
class LocationPermissionService {
  Future<void> checkAndRequestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw const LocationServiceException(
        'Location services are disabled. Please enable them in settings.',
        LocationErrorType.serviceDisabled,
      );
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationServiceException(
        'Location permission was denied. Please allow access to continue.',
        LocationErrorType.permissionDenied,
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        'Location permission was permanently denied. Enable it from app settings.',
        LocationErrorType.permissionDeniedForever,
      );
    }
  }
}

class LocationServiceException implements Exception {
  const LocationServiceException(this.message, this.type);

  final String message;
  final LocationErrorType type;

  @override
  String toString() => message;
}

enum LocationErrorType {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
}
