import 'package:get_it/get_it.dart';
import 'package:staywithme_passenger_application/service/authentication/auth_service.dart';
import 'package:staywithme_passenger_application/service/authentication/firebase_service.dart';
import 'package:staywithme_passenger_application/service/authentication/google_auth_service.dart';
import 'package:staywithme_passenger_application/service/user/user_service.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<IAuthenticateByGoogleService>(
      () => AuthenticateByGoogleService());
  locator
      .registerLazySingleton<IAuthenticateService>(() => AuthenticateService());
  locator.registerLazySingleton<IFirebaseService>(() => FirebaseServcie());
  locator.registerLazySingleton<IUserService>(() => UserService());
}
