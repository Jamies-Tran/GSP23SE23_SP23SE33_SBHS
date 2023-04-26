import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:staywithme_passenger_application/bloc/event/rating_homestay_event.dart';
import 'package:staywithme_passenger_application/bloc/rating_homestay_bloc.dart';
import 'package:staywithme_passenger_application/bloc/state/rating_homestay_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/service/image_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class RatingHomestayScreen extends StatefulWidget {
  const RatingHomestayScreen({super.key});
  static const String ratingHomestayScreenRoute = "/rating-homestay";

  @override
  State<RatingHomestayScreen> createState() => _RatingHomestayScreenState();
}

class _RatingHomestayScreenState extends State<RatingHomestayScreen> {
  final ratingHomestayBloc = RatingHomestayBloc();
  final imageService = locator.get<IImageService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RatingHomestayState>(
        stream: ratingHomestayBloc.stateController.stream,
        initialData: ratingHomestayBloc.initData(context),
        builder: (context, streamSnapshot) {
          String? homestayImageUrl;
          String? homestayName;
          String? address;
          double? totalAverageRating;
          switch (streamSnapshot.data!.homestayType) {
            case "homestay":
              homestayImageUrl = streamSnapshot.data!.bookingHomestay!.homestay!
                  .homestayImages!.first.imageUrl!;
              homestayName =
                  streamSnapshot.data!.bookingHomestay!.homestay!.name!;
              address = streamSnapshot.data!.bookingHomestay!.homestay!.address!
                  .split(",")
                  .first;
              totalAverageRating = double.parse(streamSnapshot
                  .data!.bookingHomestay!.homestay!.totalAverageRating!
                  .toStringAsFixed(2));
              break;
            case "bloc":
              homestayImageUrl = streamSnapshot.data!.booking!.bloc!.homestays!
                  .first.homestayImages!.first.imageUrl!;
              homestayName = streamSnapshot.data!.booking!.bloc!.name!;
              address =
                  streamSnapshot.data!.booking!.bloc!.address!.split(",").first;
              totalAverageRating = double.parse(streamSnapshot
                  .data!.booking!.bloc!.totalAverageRating!
                  .toStringAsFixed(2));
              break;
          }

          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              backgroundColor: primaryColor,
              body: SafeArea(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    !streamSnapshot.data!.isRatingFinished!
                        ? SizedBox(
                            child: Column(
                              children: [
                                TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0, end: 10),
                                  duration: const Duration(seconds: 3),
                                  builder: (context, value, child) =>
                                      SizedBox(height: value, child: child),
                                  child: const SizedBox(),
                                ),
                                Center(
                                  child: TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0, end: 1),
                                    duration: const Duration(seconds: 2),
                                    builder: (context, value, child) => Opacity(
                                      opacity: value,
                                      child: child,
                                    ),
                                    child: const Text(
                                      "Feedback for",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                                TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0, end: 15),
                                  duration: const Duration(seconds: 3),
                                  builder: (context, value, child) =>
                                      SizedBox(height: value, child: child),
                                  child: const SizedBox(),
                                ),
                                TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0, end: 1),
                                    duration: const Duration(seconds: 2),
                                    builder: (context, value, child) => Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                    child: Container(
                                      width: 300,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          border: Border.all(
                                              width: 1.0,
                                              style: BorderStyle.solid),
                                          boxShadow: const <BoxShadow>[
                                            BoxShadow(
                                                blurRadius: 1.0,
                                                blurStyle: BlurStyle.outer,
                                                offset: Offset(2.0, 2.0))
                                          ]),
                                      child: Row(children: [
                                        Expanded(
                                          flex: 1,
                                          child: FutureBuilder(
                                            future:
                                                imageService.getHomestayImage(
                                                    homestayImageUrl!),
                                            builder: (context, imgSnapshot) {
                                              switch (
                                                  imgSnapshot.connectionState) {
                                                case ConnectionState.waiting:
                                                  return Container(
                                                    width: 30,
                                                    height: 30,
                                                    color: Colors.white24,
                                                  );
                                                case ConnectionState.done:
                                                  final imageData =
                                                      imgSnapshot.data;
                                                  String imageUrl = imageData ??
                                                      "https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg";
                                                  return AdvancedAvatar(
                                                    image:
                                                        NetworkImage(imageUrl),
                                                  );
                                                default:
                                                  break;
                                              }
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                width: 30,
                                                height: 30,
                                                color: Colors.white24,
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  utf8.decode(homestayName!
                                                      .runes
                                                      .toList()),
                                                  style: const TextStyle(
                                                      fontFamily: "Lobster",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                      Icons.location_on,
                                                      color: Colors.green,
                                                      size: 15,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(utf8.decode(address!
                                                        .runes
                                                        .toList())),
                                                  ],
                                                ),
                                                Row(children: [
                                                  const Icon(Icons.star,
                                                      color: Colors.yellow,
                                                      size: 15),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text("$totalAverageRating",
                                                      style: const TextStyle(
                                                          fontSize: 15))
                                                ]),
                                              ]),
                                        ),
                                      ]),
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: const Duration(seconds: 2),
                                  builder: (context, value, child) => Opacity(
                                    opacity: value,
                                    child: child,
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Security Feedback",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            letterSpacing: 2.0),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      RatingStars(
                                        animationDuration:
                                            const Duration(seconds: 3),
                                        maxValue: 5,
                                        maxValueVisibility: false,
                                        valueLabelVisibility: false,
                                        starColor: Colors.yellow,
                                        starOffColor: Colors.grey,
                                        starSpacing: 2.0,
                                        starSize: 30,
                                        onValueChanged: (value) {
                                          ratingHomestayBloc
                                              .eventController.sink
                                              .add(
                                                  RatingSecurityForHomestayEvent(
                                                      securityPoint: value));
                                        },
                                        value:
                                            streamSnapshot.data!.securityPoint!,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "How do you feel about the security here?",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black45),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 250,
                                        child: Stack(
                                          children: const [
                                            Divider(
                                                color: Colors.black,
                                                indent: 1.0,
                                                endIndent: 1.0,
                                                thickness: 1.0),
                                            Center(
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.black,
                                                size: 17,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "Service Feedback",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            letterSpacing: 2.0),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      RatingStars(
                                        animationDuration:
                                            const Duration(seconds: 3),
                                        maxValue: 5,
                                        maxValueVisibility: false,
                                        valueLabelVisibility: false,
                                        starColor: Colors.yellow,
                                        starOffColor: Colors.grey,
                                        starSpacing: 2.0,
                                        starSize: 30,
                                        onValueChanged: (value) {
                                          ratingHomestayBloc
                                              .eventController.sink
                                              .add(
                                                  RatingServiceForHomestayEvent(
                                                      servicePoint: value));
                                        },
                                        value:
                                            streamSnapshot.data!.servicePoint!,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "How satisfied are you about the service?",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black45),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 250,
                                        child: Stack(
                                          children: const [
                                            Divider(
                                                color: Colors.black,
                                                indent: 1.0,
                                                endIndent: 1.0,
                                                thickness: 1.0),
                                            Center(
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.black,
                                                size: 17,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "Location Feedback",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            letterSpacing: 2.0),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      RatingStars(
                                        animationDuration:
                                            const Duration(seconds: 3),
                                        maxValue: 5,
                                        maxValueVisibility: false,
                                        valueLabelVisibility: false,
                                        starColor: Colors.yellow,
                                        starOffColor: Colors.grey,
                                        starSpacing: 2.0,
                                        starSize: 30,
                                        onValueChanged: (value) {
                                          ratingHomestayBloc
                                              .eventController.sink
                                              .add(
                                                  RatingLocationForHomestayEvent(
                                                      locationPoint: value));
                                        },
                                        value:
                                            streamSnapshot.data!.locationPoint!,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "How convenient of homestay location?",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black45),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      SizedBox(
                                        width: 300,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintText:
                                                  "leave your comment here...",
                                              hintStyle: TextStyle(
                                                  fontFamily: "Lobster"),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2.0)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2.0))),
                                          onChanged: (value) {
                                            ratingHomestayBloc
                                                .eventController.sink
                                                .add(CommentForHomestayEvent(
                                                    comment: value));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0, end: 20),
                                  duration: const Duration(seconds: 3),
                                  builder: (context, value, child) =>
                                      SizedBox(height: value, child: child),
                                  child: const SizedBox(),
                                ),
                                TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: const Duration(seconds: 2),
                                  builder: (context, value, child) =>
                                      Opacity(opacity: value, child: child),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.greenAccent,
                                          maximumSize: const Size(150, 50),
                                          minimumSize: const Size(150, 50)),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                              content: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: Column(
                                              children: [
                                                const Text(
                                                  "Submit your feedback?",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      primaryColor),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            "Later",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Lobster",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green),
                                                          onPressed: () {
                                                            ratingHomestayBloc
                                                                .eventController
                                                                .sink
                                                                .add(SubmitRatingHomestayEvent(
                                                                    context:
                                                                        context,
                                                                    rating: streamSnapshot
                                                                        .data!
                                                                        .ratingModel()));
                                                          },
                                                          child: const Text(
                                                            "Submit",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Lobster",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ))
                                                  ],
                                                )
                                              ],
                                            ),
                                          )),
                                        );
                                      },
                                      child: const Text(
                                        "Feedback",
                                        style: TextStyle(
                                            fontFamily: "Lobster",
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0, end: 5),
                                  duration: const Duration(seconds: 3),
                                  builder: (context, value, child) =>
                                      SizedBox(height: value, child: child),
                                  child: const SizedBox(),
                                ),
                                TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: const Duration(seconds: 2),
                                  builder: (context, value, child) =>
                                      Opacity(opacity: value, child: child),
                                  child: TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: SizedBox(
                                              height: 90,
                                              width: 100,
                                              child: Column(children: [
                                                const Text(
                                                    "Do you want to skip Feedback?"),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      primaryColor),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            "Back",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Lobster",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .greenAccent),
                                                          onPressed: () {
                                                            ratingHomestayBloc
                                                                .eventController
                                                                .sink
                                                                .add(BackToBookingScreen(
                                                                    context:
                                                                        context));
                                                          },
                                                          child: const Text(
                                                            "Go back to homepage",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Lobster",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                    )
                                                  ],
                                                )
                                              ]),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Skip",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            decoration:
                                                TextDecoration.underline),
                                      )),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            child: TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: const Duration(seconds: 3),
                              builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: child,
                              ),
                              child: Column(children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                ),
                                const Text(
                                  "Thank you for your feedback",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const Text(
                                  "Your opinion will help us improve",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.greenAccent,
                                      maximumSize: const Size(200, 50),
                                      minimumSize: const Size(200, 50)),
                                  onPressed: () {
                                    ratingHomestayBloc.eventController.sink.add(
                                        BackToBookingScreen(context: context));
                                  },
                                  child: const Text("Go Back",
                                      style: TextStyle(
                                          fontFamily: "Lobster",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                )
                              ]),
                            ),
                          ),
                    !streamSnapshot.data!.isRatingFinished!
                        ? const SizedBox()
                        : SizedBox(
                            height: MediaQuery.of(context).size.height / 12,
                          ),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 20),
                      duration: const Duration(seconds: 3),
                      builder: (context, value, child) =>
                          SizedBox(height: value, child: child),
                      child: const SizedBox(),
                    ),
                    SizedBox(
                      width: 250,
                      child: Stack(
                        children: const [
                          Divider(
                              color: Colors.black,
                              indent: 1.0,
                              endIndent: 1.0,
                              thickness: 1.0),
                          Center(
                            child: Icon(
                              Icons.holiday_village,
                              color: Colors.black,
                              size: 17,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 2),
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: child,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Keep on with your journey",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FutureBuilder(
                            future:
                                streamSnapshot.data!.getSimilarHomestayList(),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return SizedBox(
                                    height: 350,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      itemCount: 5,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return TweenAnimationBuilder(
                                          tween:
                                              Tween<double>(begin: 0, end: 1),
                                          duration:
                                              Duration(seconds: index + 1),
                                          builder: (context, value, child) =>
                                              Opacity(
                                            opacity: value,
                                            child: child,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 150,
                                                width: 250,
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                padding: const EdgeInsets.only(
                                                  top: 50,
                                                ),
                                                decoration: const BoxDecoration(
                                                    color: Colors.white24,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10))),
                                              ),
                                              Container(
                                                height: 150,
                                                width: 250,
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                case ConnectionState.done:
                                  if (snapshot.hasData) {
                                    final homestayListData = snapshot.data;
                                    if (homestayListData
                                        is List<HomestayModel>) {
                                      return SizedBox(
                                        height: 350,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: homestayListData.length,
                                            itemBuilder:
                                                (context, index) =>
                                                    TweenAnimationBuilder(
                                                      tween: Tween<double>(
                                                          begin: 0, end: 1),
                                                      duration: Duration(
                                                          seconds: index + 1),
                                                      builder: (context, value,
                                                              child) =>
                                                          Opacity(
                                                        opacity: value,
                                                        child: child,
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          FutureBuilder(
                                                            future: imageService
                                                                .getHomestayImage(
                                                                    homestayListData[
                                                                            index]
                                                                        .homestayImages![
                                                                            0]
                                                                        .imageUrl!),
                                                            builder: (context,
                                                                imageSnapshot) {
                                                              switch (imageSnapshot
                                                                  .connectionState) {
                                                                case ConnectionState
                                                                    .waiting:
                                                                  return Container(
                                                                    height: 150,
                                                                    width: 250,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      top: 50,
                                                                    ),
                                                                    decoration: const BoxDecoration(
                                                                        color: Colors
                                                                            .white24,
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(10),
                                                                            topRight: Radius.circular(10))),
                                                                  );
                                                                case ConnectionState
                                                                    .done:
                                                                  String
                                                                      imageUrl =
                                                                      imageSnapshot
                                                                              .data ??
                                                                          'https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg';
                                                                  return Container(
                                                                    height: 150,
                                                                    width: 250,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      top: 50,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image: NetworkImage(
                                                                                imageUrl),
                                                                            fit: BoxFit
                                                                                .fill),
                                                                        borderRadius: const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(10),
                                                                            topRight: Radius.circular(10))),
                                                                  );
                                                                default:
                                                                  break;
                                                              }
                                                              return Container(
                                                                height: 150,
                                                                width: 200,
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  top: 50,
                                                                ),
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .white24,
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                10),
                                                                        topRight:
                                                                            Radius.circular(10))),
                                                              );
                                                            },
                                                          ),
                                                          Container(
                                                            height: 150,
                                                            width: 250,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            decoration: const BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10)),
                                                                color: Colors
                                                                    .white),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          utf8.decode(homestayListData[index]
                                                                              .name!
                                                                              .runes
                                                                              .toList()),
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Icon(
                                                                            Icons
                                                                                .location_on,
                                                                            color:
                                                                                Colors.amber,
                                                                            size: 15),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                            utf8.decode(homestayListData[index].address!.split(",").first.runes.toList()),
                                                                            style: const TextStyle(fontSize: 15))
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                        children: [
                                                                          const Icon(
                                                                            Icons.star,
                                                                            color:
                                                                                Colors.yellow,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 10),
                                                                          Text(
                                                                              "${double.parse(homestayListData[index].totalAverageRating!.toStringAsFixed(2))} (Rating count ${homestayListData[index].numberOfRating})")
                                                                        ]),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .attach_money_sharp,
                                                                          color:
                                                                              Colors.green,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                            "${currencyFormat.format(homestayListData[index].price)} VND / day",
                                                                            style:
                                                                                const TextStyle(fontSize: 15)),
                                                                      ],
                                                                    )
                                                                  ]),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                      );
                                    }
                                  }
                                  break;
                                default:
                                  break;
                              }
                              return const SizedBox();
                            },
                          )
                        ],
                      ),
                    )
                  ],
                )),
              ),
            ),
          );
        });
  }
}
