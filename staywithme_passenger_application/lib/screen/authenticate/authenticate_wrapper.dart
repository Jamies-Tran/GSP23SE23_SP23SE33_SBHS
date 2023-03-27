import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/screen/authenticate/log_in_screen.dart';

import 'package:staywithme_passenger_application/screen/personal/info_management_screen.dart';
import 'package:staywithme_passenger_application/service/share_preference/share_preference.dart';

class AuthenticateWrapperScreen extends StatelessWidget {
  const AuthenticateWrapperScreen({super.key});
  static const String authenticateWrapperScreenRoute = "/authenticate_wrapper";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferencesService.initSharedPreferenced(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const SizedBox();
          case ConnectionState.done:
            final data = snapshot.data!;
            bool? isLogin = data.containsKey("userLoginInfo");
            if (isLogin == true) {
              List<String> userLoginInfo = data.getStringList("userLoginInfo")!;
              return PassengerInfoManagementScreen(
                username: userLoginInfo[0],
              );
            } else {
              return const LoginScreen();
            }

          default:
            break;
        }

        return const LoginScreen();
      },
    );
  }
}
