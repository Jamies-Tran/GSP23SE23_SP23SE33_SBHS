import 'package:geolocator/geolocator.dart';
import 'package:staywithme_passenger_application/service/share_preference/share_preference.dart';

abstract class ILocationService {
  Future<dynamic> getUserCurrentLocation();
}

class LocationService extends ILocationService {
  @override
  Future getUserCurrentLocation() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    final sharedPreferences =
        await SharedPreferencesService.initSharedPreferenced();
    if (isServiceEnabled == false) {
      return null;
    }
    final checkLocationPermission = await Geolocator.checkPermission();
    if (checkLocationPermission.name == LocationPermission.denied.name) {
      final requestPermission = await Geolocator.requestPermission();
      if (requestPermission.name == LocationPermission.denied.name) {
        sharedPreferences.setBool("locationPermission", false);
        sharedPreferences.setBool("permissionDeniedForever", false);
        if (sharedPreferences.containsKey("latitude")) {
          sharedPreferences.remove("latitude");
        }
        if (sharedPreferences.containsKey("longitude")) {
          sharedPreferences.remove("longitude");
        }
        return null;
      } else if (requestPermission.name ==
          LocationPermission.deniedForever.name) {
        sharedPreferences.setBool("locationPermission", false);
        sharedPreferences.setBool("permissionDeniedForever", true);
        if (sharedPreferences.containsKey("latitude")) {
          sharedPreferences.remove("latitude");
        }
        if (sharedPreferences.containsKey("longitude")) {
          sharedPreferences.remove("longitude");
        }
        return null;
      }
    } else if (checkLocationPermission.name ==
        LocationPermission.deniedForever.name) {
      sharedPreferences.setBool("locationPermission", false);
      sharedPreferences.setBool("permissionDeniedForever", true);
      if (sharedPreferences.containsKey("latitude")) {
        sharedPreferences.remove("latitude");
      }
      if (sharedPreferences.containsKey("longitude")) {
        sharedPreferences.remove("longitude");
      }
      return null;
    }
    sharedPreferences.setBool("locationPermission", true);
    sharedPreferences.setBool("permissionDeniedForever", false);
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    sharedPreferences.setDouble("longitude", position.longitude);
    sharedPreferences.setDouble("latitude", position.latitude);
    return position;
  }
}
