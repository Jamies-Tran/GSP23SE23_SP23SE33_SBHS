import 'package:geolocator/geolocator.dart';

abstract class ILocationService {
  Future<dynamic> getUserCurrentLocation();
}

class LocationService extends ILocationService {
  @override
  Future getUserCurrentLocation() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isServiceEnabled == false) {
      return null;
    }
    final checkLocationPermission = await Geolocator.checkPermission();
    if (checkLocationPermission.name == LocationPermission.denied.name) {
      final requestPermission = await Geolocator.requestPermission();
      if (requestPermission.name == LocationPermission.denied.name) {
        return null;
      } else if (requestPermission.name ==
          LocationPermission.deniedForever.name) {
        return null;
      }
    } else if (checkLocationPermission.name ==
        LocationPermission.deniedForever.name) {
      return null;
    }

    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}
