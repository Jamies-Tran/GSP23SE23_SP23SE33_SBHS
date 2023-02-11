import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/screen/authenticate/log_in_screen.dart';
import 'package:staywithme_passenger_application/screen/personal/info_management_screen.dart';

class AuthenticateWrapperScreen extends StatelessWidget {
  const AuthenticateWrapperScreen({super.key});
  static const String authenticateWrapperScreenRoute = "/authenticate_wrapper";

  @override
  Widget build(BuildContext context) {
    final fireAuth = FirebaseAuth.instance;
    // dynamic contextArguments =
    //     ModalRoute.of(context)!.settings.arguments as Map?;
    // String? username = contextArguments != null
    //     ? contextArguments["username"]
    //     : "passenger002";
    //final fireAuthService = locator.get<IAuthenticateByGoogleService>();

    return StreamBuilder(
      stream: fireAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PassengerInfoManagementScreen(
            username: snapshot.data!.displayName,
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
