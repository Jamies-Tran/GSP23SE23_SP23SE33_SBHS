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
    //final fireAuthService = locator.get<IAuthenticateByGoogleService>();

    return StreamBuilder(
      stream: fireAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //User? user = snapshot.data;
          return const PassengerInfoManagementScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
