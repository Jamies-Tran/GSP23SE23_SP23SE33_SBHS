import 'package:get_it/get_it.dart';
import 'package:staywithme_passenger_application/service/authentication/auth_service.dart';
import 'package:staywithme_passenger_application/service/authentication/firebase_service.dart';
import 'package:staywithme_passenger_application/service/authentication/google_auth_service.dart';
import 'package:staywithme_passenger_application/service/image_service.dart';
import 'package:staywithme_passenger_application/service/location/location_service.dart';
import 'package:staywithme_passenger_application/service/user/auto_complete_service.dart';
import 'package:staywithme_passenger_application/service/homestay/homestay_service.dart';
import 'package:staywithme_passenger_application/service/user/payment_service.dart';
import 'package:staywithme_passenger_application/service/user/user_service.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<IAuthenticateByGoogleService>(
      () => AuthenticateByGoogleService());
  locator
      .registerLazySingleton<IAuthenticateService>(() => AuthenticateService());
  locator.registerLazySingleton<IFirebaseService>(() => FirebaseServcie());
  locator.registerLazySingleton<IUserService>(() => UserService());
  locator.registerLazySingleton<IPaymentService>(() => PaymentService());
  locator
      .registerLazySingleton<IAutoCompleteService>(() => AutoCompleteService());
  locator.registerLazySingleton<IHomestayService>(() => HomestayService());
  locator.registerLazySingleton<ILocationService>(() => LocationService());
  locator.registerLazySingleton<IImageService>(() => ImageService());
}
