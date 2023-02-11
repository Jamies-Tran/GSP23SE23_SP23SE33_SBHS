import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/model/passenger_model.dart';
import 'package:staywithme_passenger_application/service/authentication/google_auth_service.dart';
import 'package:staywithme_passenger_application/service/user/user_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class PassengerInfoManagementScreen extends StatelessWidget {
  const PassengerInfoManagementScreen({super.key, this.username});
  final String? username;
  static const passengerInfoManagementScreenRoute = "/info-management";

  @override
  Widget build(BuildContext context) {
    final fireAuthService = locator.get<IAuthenticateByGoogleService>();
    final userService = locator.get<IUserService>();
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: userService.getPassengerPersonalInformation(username!),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SpinKitCircle(
                          color: Colors.amber,
                        ),
                        Text("Getting your information")
                      ],
                    ),
                  );
                case ConnectionState.done:
                  final data = snapshot.data;
                  if (data is PassengerModel) {
                    return SingleChildScrollView(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            const AdvancedAvatar(
                              image: AssetImage("images/login_background.jpg"),
                            ),
                            Text(utf8.decode(data.username!.runes.toList())),
                            ElevatedButton(
                                onPressed: () => fireAuthService.signOut(),
                                child: Text("sign out"))
                          ],
                        )
                      ],
                    ));
                  } else {
                    return ElevatedButton(
                        onPressed: () => fireAuthService.signOut(),
                        child: Text("sign out"));
                  }

                default:
                  break;
              }
              return const Center(
                child: SpinKitCircle(color: Colors.amber),
              );
            }),
      ),
    );
  }
}
