import 'package:geolocator/geolocator.dart';

class LocationPermissionService {

  Future<void> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Location service disabled");
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("Permission denied");
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Permission permanently denied");
    }
  }
}