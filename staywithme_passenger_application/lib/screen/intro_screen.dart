import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/screen/main_screen.dart';
import 'package:staywithme_passenger_application/service/location/location_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});
  static const String instroScreenRoute = "/instro-screen";

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final locationService = locator.get<ILocationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primaryColor,
        child: FutureBuilder(
          future: locationService.getUserCurrentLocation(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: child,
                  ),
                  child: Center(child: Image.asset("images/swm.png")),
                );
              case ConnectionState.done:
                final data = snapshot.data as Position?;
                return MainScreen(
                  position: data,
                );
              default:
                break;
            }
            return Center(
              child: Image.asset("images/swm.png"),
            );
          },
        ),
      ),
    );
  }
}
