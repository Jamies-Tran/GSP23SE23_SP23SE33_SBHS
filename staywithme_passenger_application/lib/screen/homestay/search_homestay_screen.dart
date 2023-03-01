import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/service/location/location_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class SearchHomestayScreen extends StatefulWidget {
  const SearchHomestayScreen({super.key});
  static const String searchHomestayScreenRoute = "/search_homestay";

  @override
  State<SearchHomestayScreen> createState() => _SearchHomestayScreenState();
}

class _SearchHomestayScreenState extends State<SearchHomestayScreen> {
  final locationService = locator.get<ILocationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(top: 20),
        color: secondaryColor,
        child: FutureBuilder(
          future: locationService.getUserCurrentLocation(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SpinKitFadingCircle(
                      color: Colors.black,
                      duration: Duration(seconds: 4),
                    ),
                    Text(
                      "Getting your location...",
                      style:
                          TextStyle(fontFamily: "Lobster", color: Colors.black),
                    )
                  ],
                );
              case ConnectionState.done:
                final data = snapshot.data;
                return SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: [
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(seconds: 3),
                          builder: (context, value, child) =>
                              Opacity(opacity: value, child: child),
                          child: SizedBox(
                            width: 320,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Search homestay...",
                                hintStyle: TextStyle(
                                    fontFamily: "Lobster",
                                    color: Colors.black45),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: secondaryColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: secondaryColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        data is Position
                            ? TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0, end: 1),
                                duration: const Duration(seconds: 5),
                                builder: (context, value, child) => Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: primaryColor),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.location_on),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Near me",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                );

              default:
                break;
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
