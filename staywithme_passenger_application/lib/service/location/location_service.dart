import 'package:geolocator/geolocator.dart';

abstract class ILocationService {
  Future<dynamic> getUserCurrentLocation();
}

class LocationService extends ILocationService {
  @override
  Future getUserCurrentLocation() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isServiceEnabled == false) {
      return "Location Service disable";
    }
    final checkLocationPermission = await Geolocator.checkPermission();
    if (checkLocationPermission.name == LocationPermission.denied.name) {
      final requestPermission = await Geolocator.requestPermission();
      if (requestPermission.name == LocationPermission.denied.name) {
        return "user don't want to share location";
      } else if (requestPermission.name ==
          LocationPermission.deniedForever.name) {
        return "user deny to share location forever";
      }
    } else if (checkLocationPermission.name ==
        LocationPermission.deniedForever.name) {
      return "user deny to share location forever";
    }

    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}
