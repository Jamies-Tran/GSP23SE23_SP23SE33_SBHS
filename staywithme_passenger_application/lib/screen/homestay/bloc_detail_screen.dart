import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:staywithme_passenger_application/bloc/bloc_detail_bloc.dart';
import 'package:staywithme_passenger_application/bloc/event/bloc_detail_event.dart';
import 'package:staywithme_passenger_application/bloc/state/bloc_detail_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/service/homestay/homestay_service.dart';
import 'package:staywithme_passenger_application/service/image_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class BlocDetailScreen extends StatefulWidget {
  const BlocDetailScreen({super.key});
  static const blocDetailScreenRoute = "/bloc-detail";

  @override
  State<BlocDetailScreen> createState() => _BlocDetailScreenState();
}

class _BlocDetailScreenState extends State<BlocDetailScreen> {
  final blocHomestayDetailBloc = BlocHomestayDetailBloc();
  final firebaseAuth = FirebaseAuth.instance;
  final homestayService = locator.get<IHomestayService>();
  final imageService = locator.get<IImageService>();

  final bookingStartDateTextEditingController = TextEditingController();
  final bookingEndDateTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<BlocHomestayDetailState>(
        stream: blocHomestayDetailBloc.stateController.stream,
        initialData: blocHomestayDetailBloc.initData(context),
        builder: (context, streamSnapshot) {
          return SafeArea(
            child: FutureBuilder(
              future: homestayService
                  .getBlocDetailByName(streamSnapshot.data!.name!),
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
                    if (snapshot.hasData) {
                      final blocData = snapshot.data;

                      if (blocData is BlocHomestayModel) {
                        blocData.homestays!.sort(
                          (a, b) => a.price!.compareTo(b.price!),
                        );
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: FutureBuilder(
                                        future: imageService.getHomestayImage(
                                            blocData
                                                .homestays!
                                                .first
                                                .homestayImages!
                                                .first
                                                .imageUrl!),
                                        builder: (context, imgSnapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return Container(
                                                width: 450,
                                                height: 200,
                                                color: Colors.white24,
                                              );
                                            case ConnectionState.done:
                                              final imageData =
                                                  imgSnapshot.data;
                                              String imageUrl = imageData ??
                                                  "https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg";
                                              return Container(
                                                width: 450,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            imageUrl),
                                                        fit: BoxFit.fill)),
                                                padding: const EdgeInsets.only(
                                                    left: 225),
                                                child: Opacity(
                                                  opacity: 0.5,
                                                  child: Container(
                                                    color: Colors.black,
                                                    child: Center(
                                                      child: Text(
                                                        "+${blocData.homestays!.length} more",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            default:
                                              break;
                                          }
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            width: 450,
                                            height: 200,
                                            color: Colors.white24,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 15, right: 10),
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      utf8.decode(
                                          blocData.name!.runes.toList()),
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Lobster",
                                          color: primaryColor),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.amber,
                                          size: 15,
                                        ),
                                        Text(
                                          "${utf8.decode(blocData.address!.split(",").first.runes.toList())}, ${utf8.decode(blocData.address!.split(",").last.runes.toList())}",
                                          style: const TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    streamSnapshot.data!.onCampaign(blocData)
                                        ? Row(
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.attach_money,
                                                    color: Colors.green,
                                                    size: 15,
                                                  ),
                                                  Text(
                                                    "${currencyFormat.format(blocData.homestays!.first.price)} ~ ${currencyFormat.format(blocData.homestays!.last.price)}",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        color: Colors.red),
                                                  ),
                                                  Text(
                                                    "${currencyFormat.format(streamSnapshot.data!.newHomestayInBlocPrice(blocData, blocData.homestays!.first))} ~ ${currencyFormat.format(streamSnapshot.data!.newHomestayInBlocPrice(blocData, blocData.homestays!.last))}đ/day",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              const Icon(
                                                Icons.attach_money,
                                                color: Colors.green,
                                                size: 15,
                                              ),
                                              Text(
                                                "${currencyFormat.format(blocData.homestays!.first.price)} ~ ${currencyFormat.format(blocData.homestays!.last.price)} đ/day",
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              )
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              streamSnapshot.data!.onCampaign(blocData)
                                  ? Column(
                                      children: [
                                        const Text("Block is on campaign: ",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black45)),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 90,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: secondaryColor),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  utf8.decode(streamSnapshot
                                                      .data!
                                                      .campaign(blocData)!
                                                      .name!
                                                      .runes
                                                      .toList()),
                                                  style: const TextStyle(
                                                      fontFamily: "Lobster",
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black45)),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text("Discount for: "),
                                                  Text(
                                                      "${streamSnapshot.data!.campaign(blocData)!.discountPercentage} %",
                                                      style: const TextStyle(
                                                          fontFamily: "Lobster",
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black))
                                                ],
                                              ),
                                              Text(
                                                  "${dateFormat.parseUTC(streamSnapshot.data!.campaign(blocData)!.endDate!).difference(dateFormat.parse(DateTime.now().toString())).inDays} days left",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 15))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 5),
                                child: ConfirmationSlider(
                                  onConfirmation: () {
                                    blocHomestayDetailBloc.eventController.sink
                                        .add(ChooseBookingDateForBlocEvent(
                                            context: context, bloc: blocData));
                                  },
                                  width: 300,
                                  backgroundColor: primaryColor,
                                  backgroundColorEnd: Colors.green,
                                  sliderButtonContent:
                                      const Icon(Icons.app_registration),
                                  foregroundColor: Colors.green,
                                  stickToEnd: true,
                                  text: "Slide to book",
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: 300,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          blurRadius: 1.0,
                                          offset: Offset(2.0, 2.0),
                                          blurStyle: BlurStyle.outer)
                                    ]),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: RatingStars(
                                          starColor: primaryColor,
                                          starOffColor: Colors.grey,
                                          maxValueVisibility: false,
                                          valueLabelVisibility: false,
                                          maxValue: 5,
                                          starCount: 5,
                                          starSize: 25,
                                          starSpacing: 20,
                                          value: double.parse(blocData
                                              .totalAverageRating!
                                              .toStringAsFixed(2)),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 50, right: 50),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      "Security: ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${streamSnapshot.data!.averageRating(blocData.ratings!, "SECURITY")}",
                                                        style: const TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .lightBlueAccent),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      const Icon(
                                                        Icons.star,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      "Service: ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${streamSnapshot.data!.averageRating(blocData.ratings!, "SERVICE")}",
                                                        style: const TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.amber),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      "Location: ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${streamSnapshot.data!.averageRating(blocData.ratings!, "LOCATION")}",
                                                        style: const TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .greenAccent),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      const Icon(
                                                        Icons.star,
                                                        color:
                                                            Colors.greenAccent,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  SizedBox(width: 10),
                                  Text("Block Feedback(s)",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: primaryColor)),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              blocData.ratings!.isNotEmpty
                                  ? SizedBox(
                                      height: 120,
                                      width: MediaQuery.of(context).size.width,
                                      child: blocData.ratings!.length == 1
                                          ? Container(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              margin: const EdgeInsets.only(
                                                  left: 50, right: 50),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: const <BoxShadow>[
                                                    BoxShadow(
                                                        blurRadius: 1.0,
                                                        offset:
                                                            Offset(2.0, 2.0),
                                                        blurStyle:
                                                            BlurStyle.outer)
                                                  ]),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: FutureBuilder(
                                                      future: imageService
                                                          .getHomestayImage(
                                                              blocData
                                                                  .ratings!
                                                                  .first
                                                                  .avatar!),
                                                      builder: (context,
                                                          imgSnapshot) {
                                                        switch (snapshot
                                                            .connectionState) {
                                                          case ConnectionState
                                                              .waiting:
                                                            return Container(
                                                              width: 450,
                                                              height: 200,
                                                              color: Colors
                                                                  .white24,
                                                            );
                                                          case ConnectionState
                                                              .done:
                                                            final imageData =
                                                                imgSnapshot
                                                                    .data;
                                                            String imageUrl =
                                                                imageData ??
                                                                    "https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg";
                                                            return AdvancedAvatar(
                                                              size: 70,
                                                              image:
                                                                  NetworkImage(
                                                                      imageUrl),
                                                            );
                                                          default:
                                                            break;
                                                        }
                                                        return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  right: 10),
                                                          width: 450,
                                                          height: 200,
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          utf8.decode(blocData
                                                              .ratings!
                                                              .first
                                                              .username!
                                                              .runes
                                                              .toList()),
                                                          overflow:
                                                              TextOverflow.fade,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Row(children: [
                                                              Text(
                                                                "${double.parse(blocData.ratings!.first.securityPoint!.toStringAsFixed(2))}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .lightBlue,
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                              const Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .lightBlueAccent,
                                                                size: 17,
                                                              )
                                                            ]),
                                                            Row(children: [
                                                              Text(
                                                                "${double.parse(blocData.ratings!.first.servicePoint!.toStringAsFixed(2))}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .amber,
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                              const Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                                size: 17,
                                                              )
                                                            ]),
                                                            Row(children: [
                                                              Text(
                                                                "${double.parse(blocData.ratings!.first.locationPoint!.toStringAsFixed(2))}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                              const Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .green,
                                                                size: 17,
                                                              )
                                                            ]),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        blocData.ratings!.first
                                                                    .comment !=
                                                                null
                                                            ? Text(
                                                                "\" ${utf8.decode(blocData.ratings!.first.comment!.runes.toList())} \"",
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                              )
                                                            : const Text(
                                                                "No comment",
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                              )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  blocData.ratings!.length,
                                              itemBuilder: (context, index) {
                                                RatingModel rating =
                                                    blocData.ratings![index];
                                                return Container(
                                                  height: 50,
                                                  width: 250,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      boxShadow: const <
                                                          BoxShadow>[
                                                        BoxShadow(
                                                            blurRadius: 1.0,
                                                            offset: Offset(
                                                                2.0, 2.0),
                                                            blurStyle:
                                                                BlurStyle.outer)
                                                      ]),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: FutureBuilder(
                                                          future: imageService
                                                              .getHomestayImage(
                                                                  rating
                                                                      .avatar!),
                                                          builder: (context,
                                                              imgSnapshot) {
                                                            switch (snapshot
                                                                .connectionState) {
                                                              case ConnectionState
                                                                  .waiting:
                                                                return Container(
                                                                  width: 450,
                                                                  height: 200,
                                                                  color: Colors
                                                                      .white24,
                                                                );
                                                              case ConnectionState
                                                                  .done:
                                                                final imageData =
                                                                    imgSnapshot
                                                                        .data;
                                                                String
                                                                    imageUrl =
                                                                    imageData ??
                                                                        "https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg";
                                                                return AdvancedAvatar(
                                                                  size: 70,
                                                                  image: NetworkImage(
                                                                      imageUrl),
                                                                );
                                                              default:
                                                                break;
                                                            }
                                                            return Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              width: 450,
                                                              height: 200,
                                                              color: Colors
                                                                  .white24,
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
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              utf8.decode(rating
                                                                  .username!
                                                                  .runes
                                                                  .toList()),
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Row(children: [
                                                                  Text(
                                                                    "${double.parse(rating.securityPoint!.toStringAsFixed(2))}",
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .lightBlue,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  const Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .lightBlueAccent,
                                                                    size: 17,
                                                                  )
                                                                ]),
                                                                Row(children: [
                                                                  Text(
                                                                    "${double.parse(rating.servicePoint!.toStringAsFixed(2))}",
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .amber,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  const Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .amber,
                                                                    size: 17,
                                                                  )
                                                                ]),
                                                                Row(children: [
                                                                  Text(
                                                                    "${double.parse(rating.locationPoint!.toStringAsFixed(2))}",
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .green,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  const Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .green,
                                                                    size: 17,
                                                                  )
                                                                ]),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            rating.comment !=
                                                                    null
                                                                ? Text(
                                                                    "\" ${utf8.decode(rating.comment!.runes.toList())} \"",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .fade,
                                                                  )
                                                                : const Text(
                                                                    "No comment",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .fade,
                                                                  )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                    )
                                  : Container(
                                      width: 170,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const <BoxShadow>[
                                            BoxShadow(
                                                blurRadius: 1.0,
                                                blurStyle: BlurStyle.outer,
                                                offset: Offset(2.0, 2.0))
                                          ]),
                                      child: Row(
                                        children: const [
                                          Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text("No Feedback",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Block Rule(s)",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: primaryColor)),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 37.5 * blocData.homestayRules!.length,
                                margin: const EdgeInsets.only(left: 50),
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(
                                      left: 50, right: 50),
                                  scrollDirection: Axis.vertical,
                                  itemCount: blocData.homestayRules!.length,
                                  itemBuilder: (context, index) {
                                    HomestayRuleModel rule =
                                        blocData.homestayRules![index];
                                    return Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 20),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  utf8.decode(rule
                                                      .description!.runes
                                                      .toList()),
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const Expanded(
                                                flex: 1,
                                                child: Icon(
                                                  Icons.rule,
                                                  color: Colors.green,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  SizedBox(width: 10),
                                  Text("Homestay(s) In Block",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: primaryColor)),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 120,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: blocData.homestays!.length,
                                  itemBuilder: (context, index) {
                                    HomestayModel homestay =
                                        blocData.homestays![index];
                                    return GestureDetector(
                                      onTap: () {
                                        blocHomestayDetailBloc
                                            .eventController.sink
                                            .add(ViewHomestayEvent(
                                                context: context,
                                                homestayName: homestay.name));
                                      },
                                      child: Container(
                                        width: 300,
                                        margin: const EdgeInsets.only(
                                            bottom: 5, left: 5, right: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: const <BoxShadow>[
                                              BoxShadow(
                                                  blurRadius: 1.0,
                                                  blurStyle: BlurStyle.outer,
                                                  offset: Offset(2.0, 2.0),
                                                  color: Colors.black)
                                            ]),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: FutureBuilder(
                                                future: imageService
                                                    .getHomestayImage(homestay
                                                        .homestayImages!
                                                        .first
                                                        .imageUrl!),
                                                builder:
                                                    (context, imgSnapshot) {
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState
                                                        .waiting:
                                                      return Container(
                                                        width: 450,
                                                        height: 200,
                                                        color: Colors.white24,
                                                      );
                                                    case ConnectionState.done:
                                                      final imageData =
                                                          imgSnapshot.data;
                                                      String imageUrl = imageData ??
                                                          "https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg";
                                                      return AdvancedAvatar(
                                                        size: 70,
                                                        image: NetworkImage(
                                                            imageUrl),
                                                      );
                                                    default:
                                                      break;
                                                  }
                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                    width: 450,
                                                    height: 200,
                                                    color: Colors.white24,
                                                  );
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        utf8.decode(homestay
                                                            .name!.runes
                                                            .toList()),
                                                        style: const TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .door_front_door,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                      "${homestay.availableRooms} rooms"),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .people,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                      "${homestay.roomCapacity} / room")
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .attach_money,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(currencyFormat
                                                                .format(homestay
                                                                    .price)),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ]),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Block Service(s)",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: primaryColor)),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height:
                                    37.5 * blocData.homestayServices!.length,
                                margin: const EdgeInsets.only(left: 50),
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(
                                      left: 50, right: 50),
                                  scrollDirection: Axis.vertical,
                                  itemCount: blocData.homestayServices!.length,
                                  itemBuilder: (context, index) {
                                    HomestayServiceModel ser =
                                        blocData.homestayServices![index];
                                    return Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              utf8.decode(
                                                  ser.name!.runes.toList()),
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.room_service,
                                              color: Colors.green,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (blocData is ServerExceptionModel) {
                        return AlertDialog(
                          content: const Center(
                              child: Text(
                                  "our server currently on maintainance schedule, please comeback later...")),
                          actions: [
                            TextButton(
                              onPressed: () {},
                              child: const Text("Try again"),
                            )
                          ],
                        );
                      } else if (blocData is SocketException ||
                          blocData is TimeoutException) {
                        return AlertDialog(
                          content: const Center(child: Text("Network error")),
                          actions: [
                            TextButton(
                              onPressed: () {},
                              child: const Text("Try again"),
                            )
                          ],
                        );
                      }
                    } else {
                      return const SizedBox();
                    }
                    break;
                  default:
                    break;
                }
                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }
}
