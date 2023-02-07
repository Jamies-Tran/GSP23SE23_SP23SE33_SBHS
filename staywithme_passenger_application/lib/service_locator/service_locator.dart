import 'package:get_it/get_it.dart';
import 'package:staywithme_passenger_application/service/auth_service.dart';
import 'package:staywithme_passenger_application/service/firebase_service.dart';
import 'package:staywithme_passenger_application/service/google_auth_service.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<IAuthenticateByGoogleService>(
      () => AuthenticateByGoogleService());
  locator
      .registerLazySingleton<IAuthenticateService>(() => AuthenticateService());
  locator.registerLazySingleton<IFirebaseService>(() => FirebaseServcie());
}
