import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/service/homestay/homestay_service.dart';

import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class SearchHomestayScreen extends StatefulWidget {
  const SearchHomestayScreen({super.key});
  static const String searchHomestayScreenRoute = "/search_homestay";

  @override
  State<SearchHomestayScreen> createState() => _SearchHomestayScreenState();
}

class _SearchHomestayScreenState extends State<SearchHomestayScreen> {
  final homestayService = locator.get<IHomestayService>();
  final searchTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map?;
    Position? position =
        contextArguments != null ? contextArguments["position"] : null;

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(top: 20),
        color: secondaryColor,
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
                  child: TextField(
                    controller: searchTextFieldController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Search homestay...",
                      hintStyle: TextStyle(
                          fontFamily: "Lobster", color: Colors.black45),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: secondaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: secondaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              position != null
                  ? Container(
                      width: 200,
                      height: 50,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: primaryColor,
                          border: Border.fromBorderSide(
                              BorderSide(width: 2.0, color: Colors.black))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.location_off,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Near me",
                              style: TextStyle(
                                  fontFamily: "Lobster",
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 10,
              ),
              position != null
                  ? FutureBuilder(
                      future: homestayService.getHomestayNearestLocationList(
                          position.latitude,
                          position.longitude,
                          0,
                          5,
                          false,
                          false),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                SpinKitCircle(
                                  color: Colors.black,
                                  duration: Duration(seconds: 4),
                                ),
                                Text("getting your homestay...")
                              ],
                            );
                          case ConnectionState.done:
                            final data = snapshot.data;
                            if (data is HomestayListPagingModel) {
                              return SizedBox(
                                height: 600,
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: data.homestays!.length,
                                    itemBuilder: (context, index) =>
                                        TweenAnimationBuilder(
                                          tween:
                                              Tween<double>(begin: 0, end: 1),
                                          duration: const Duration(seconds: 4),
                                          builder: (context, value, child) =>
                                              Opacity(
                                            opacity: value,
                                            child: child,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 150,
                                                width: 400,
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                padding: const EdgeInsets.only(
                                                  top: 50,
                                                ),
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(data
                                                            .homestays![index]
                                                            .homestayImages![0]
                                                            .imageUrl!),
                                                        fit: BoxFit.fill),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10))),
                                              ),
                                              Container(
                                                height: 150,
                                                width: 400,
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
                                                    color: Colors.white),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 10,
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              data
                                                                  .homestays![
                                                                      index]
                                                                  .name!,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 25),
                                                            ),
                                                            Text(
                                                              "(${data.homestays![index].availableRooms} rooms)",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 25),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        RatingStars(
                                                          animationDuration:
                                                              const Duration(
                                                                  seconds: 4),
                                                          maxValue: 5.0,
                                                          starColor:
                                                              secondaryColor,
                                                          starBuilder:
                                                              (index, color) =>
                                                                  Icon(
                                                            Icons.star,
                                                            color: color,
                                                            size: 25,
                                                          ),
                                                          value: data
                                                              .homestays![index]
                                                              .totalAverageRating!,
                                                          starOffColor: Colors
                                                              .lightBlueAccent,
                                                          starCount: 5,
                                                          starSpacing: 5.0,
                                                          valueLabelVisibility:
                                                              false,
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                            "(${data.homestays![index].numberOfRating} number of reviews)"),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(utf8.decode(data
                                                            .homestays![index]
                                                            .address!
                                                            .runes
                                                            .toList())),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                            "VND: ${currencyFormat.format(data.homestays![index].price)} / day"),
                                                      ]),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                            ],
                                          ),
                                        )),
                              );
                            } else {
                              return const SizedBox();
                            }

                          default:
                            break;
                        }

                        return const SizedBox();
                      },
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
