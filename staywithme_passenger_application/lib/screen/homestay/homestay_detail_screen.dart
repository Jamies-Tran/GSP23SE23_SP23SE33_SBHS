import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:staywithme_passenger_application/bloc/event/homestay_detail_event.dart';
import 'package:staywithme_passenger_application/bloc/homestay_detail_bloc.dart';
import 'package:staywithme_passenger_application/bloc/state/homestay_detail_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/service/homestay/homestay_service.dart';
import 'package:staywithme_passenger_application/service/image_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class HomestayDetailScreen extends StatefulWidget {
  const HomestayDetailScreen({super.key});
  static const String homestayDetailScreenRoute = "/homestay-detail";

  @override
  State<HomestayDetailScreen> createState() => _HomestayDetailScreenState();
}

class _HomestayDetailScreenState extends State<HomestayDetailScreen> {
  final homestayService = locator.get<IHomestayService>();
  final imageService = locator.get<IImageService>();
  final homestayDetailBloc = HomestayDetailBloc();

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    String homestayName = contextArguments["homestayName"];
    bool isHomestayInBloc = contextArguments["isHomestayInBloc"] ?? false;
    bool bookingViewHomestayDetailFlag =
        contextArguments["bookingViewHomestayDetailFlag"] ?? false;
    bool brownseHomestayFlag = contextArguments["brownseHomestayFlag"] ?? false;
    String? bookingStart = contextArguments["bookingStart"];
    String? bookingEnd = contextArguments["bookingEnd"];
    // BlocBookingDateValidationModel? blocBookingValidation =
    //     contextArguments["blocBookingValidation"];
    // bool? viewDetail = contextArguments["viewDetail"];
    final bookingStartDateTextEditingController = TextEditingController();
    final bookingEndDateTextEditingController = TextEditingController();

    if (brownseHomestayFlag) {
      bookingStartDateTextEditingController.text = bookingStart!;
      bookingEndDateTextEditingController.text = bookingEnd!;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<HomestayDetailState>(
          stream: homestayDetailBloc.stateController.stream,
          initialData: homestayDetailBloc.iniData(),
          builder: (context, streamSnapshot) {
            return SafeArea(
              child: FutureBuilder(
                future: homestayService.getHomestayDetailByName(homestayName),
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
                        final data = snapshot.data;
                        if (data is HomestayModel) {
                          return Stack(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(children: [
                                  SizedBox(
                                    height: 200,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                            onTap: () {
                                              int index = 0;
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return AlertDialog(
                                                      content: SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 270,
                                                        child: Column(
                                                          children: [
                                                            FutureBuilder(
                                                              future: imageService
                                                                  .getHomestayImage(data
                                                                      .homestayImages![
                                                                          index]
                                                                      .imageUrl!),
                                                              builder: (context,
                                                                  imgSnapshot) {
                                                                switch (snapshot
                                                                    .connectionState) {
                                                                  case ConnectionState
                                                                      .waiting:
                                                                    return Container(
                                                                      width:
                                                                          450,
                                                                      height:
                                                                          200,
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
                                                                    return Container(
                                                                      width:
                                                                          450,
                                                                      height:
                                                                          200,
                                                                      decoration: BoxDecoration(
                                                                          image: DecorationImage(
                                                                              image: NetworkImage(imageUrl),
                                                                              fit: BoxFit.fill)),
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              225),
                                                                    );
                                                                  default:
                                                                    break;
                                                                }
                                                                return Container(
                                                                  margin: const EdgeInsets
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
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                        () {
                                                                          if (index >=
                                                                              1) {
                                                                            index =
                                                                                index - 1;
                                                                          }
                                                                        },
                                                                      );
                                                                    },
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .arrow_back_ios,
                                                                      color: Colors
                                                                          .amber,
                                                                    )),
                                                                Text(
                                                                    "${index + 1} / ${data.homestayImages!.length}"),
                                                                IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                        () {
                                                                          index =
                                                                              index + 1;
                                                                        },
                                                                      );
                                                                    },
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      color: Colors
                                                                          .amber,
                                                                    ))
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: FutureBuilder(
                                              future: imageService
                                                  .getHomestayImage(streamSnapshot
                                                      .data!
                                                      .currentHomestayImage(
                                                          data.homestayImages!)
                                                      .imageUrl!),
                                              builder: (context, imgSnapshot) {
                                                switch (
                                                    snapshot.connectionState) {
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
                                                                image:
                                                                    NetworkImage(
                                                                        imageUrl),
                                                                fit: BoxFit
                                                                    .fill)),
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 225),
                                                        child: Opacity(
                                                            opacity: 0.5,
                                                            child: Container(
                                                                color: Colors
                                                                    .black,
                                                                child:
                                                                    const Center(
                                                                  child: Text(
                                                                    "View more",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ))));
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        utf8.decode(data.name!.runes.toList()),
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Lobster",
                                            color: primaryColor),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.amber,
                                            size: 15,
                                          ),
                                          Text(
                                            "${utf8.decode(data.address!.split(",").first.runes.toList())}, ${utf8.decode(data.address!.split(",").last.runes.toList())}",
                                            style:
                                                const TextStyle(fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  streamSnapshot.data!.onCampaign(data)
                                      ? Row(
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.attach_money,
                                                  color: Colors.amber,
                                                  size: 15,
                                                ),
                                                Text(
                                                  currencyFormat
                                                      .format(data.price),
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.green),
                                                )
                                              ],
                                            ),
                                            Text(
                                              "${currencyFormat.format(streamSnapshot.data!.newPrice(data))}đ / day",
                                              style:
                                                  const TextStyle(fontSize: 15),
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
                                              "${currencyFormat.format(data.price)}đ / day",
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            )
                                          ],
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.people,
                                          color: Colors.amber, size: 15),
                                      Text(
                                        "${data.availableRooms! * data.roomCapacity!} - ${data.availableRooms} rooms(${data.roomCapacity} people / room)",
                                        style: const TextStyle(fontSize: 15),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  !isHomestayInBloc
                                      ? Row(
                                          children: [
                                            const Icon(Icons.calendar_month,
                                                color: Colors.amber, size: 15),
                                            Text(
                                              "${data.createdDate}",
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            )
                                          ],
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  streamSnapshot.data!.onCampaign(data)
                                      ? Column(
                                          children: [
                                            const Text(
                                                "Homestay is on campaign: ",
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
                                                          .campaign(data)!
                                                          .name!
                                                          .runes
                                                          .toList()),
                                                      style: const TextStyle(
                                                          fontFamily: "Lobster",
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black45)),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                          "Discount for: "),
                                                      Text(
                                                          "${streamSnapshot.data!.campaign(data)!.discountPercentage} %",
                                                          style:
                                                              const TextStyle(
                                                                  fontFamily:
                                                                      "Lobster",
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black))
                                                    ],
                                                  ),
                                                  Text(
                                                      "${dateFormat.parseUTC(streamSnapshot.data!.campaign(data)!.endDate!).difference(dateFormat.parse(DateTime.now().toString())).inDays} days left",
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
                                  isHomestayInBloc == false &&
                                          bookingViewHomestayDetailFlag == false
                                      ? Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, right: 20, bottom: 5),
                                          child: ConfirmationSlider(
                                            onConfirmation: () {
                                              homestayDetailBloc
                                                  .eventController.sink
                                                  .add(CreateBookingEvent(
                                                      context: context,
                                                      homestay: data,
                                                      brownseHomestayFlag:
                                                          brownseHomestayFlag,
                                                      bookingStart:
                                                          bookingStart,
                                                      bookingEnd: bookingEnd));
                                            },
                                            width: 300,
                                            backgroundColor: primaryColor,
                                            backgroundColorEnd: Colors.green,
                                            sliderButtonContent: const Icon(
                                                Icons.app_registration),
                                            foregroundColor: Colors.green,
                                            stickToEnd: true,
                                            text: "Slide to book",
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  const Text(
                                    "Landlord",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Lobster",
                                        color: primaryColor),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 300,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: const Border.fromBorderSide(
                                          BorderSide(
                                              color: Colors.black, width: 1.0)),
                                    ),
                                    child: Row(children: [
                                      Expanded(
                                        flex: 1,
                                        child: FutureBuilder(
                                          future: imageService.getLandlordImage(
                                              data.landlord!.avatarUrl!),
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
                                                return AdvancedAvatar(
                                                  size: 70,
                                                  image: NetworkImage(imageUrl),
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
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Name:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(utf8.decode(data
                                                    .landlord!.username!.runes
                                                    .toList()))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Text("Email:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                    child: Text(
                                                  data.landlord!.email!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Text("Phone:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(data.landlord!.phone!)
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
                                  !isHomestayInBloc
                                      ? Container(
                                          width: 300,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: const <BoxShadow>[
                                                BoxShadow(
                                                    blurRadius: 1.0,
                                                    offset: Offset(2.0, 2.0),
                                                    blurStyle: BlurStyle.outer)
                                              ]),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                    value: double.parse(data
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
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Expanded(
                                                            flex: 1,
                                                            child: Center(
                                                              child: Text(
                                                                "Security: ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black45),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${streamSnapshot.data!.averageRating(data.ratings!, "SECURITY")}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          30,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
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
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Expanded(
                                                            flex: 1,
                                                            child: Center(
                                                              child: Text(
                                                                "Service: ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black45),
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
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${streamSnapshot.data!.averageRating(data.ratings!, "SERVICE")}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          30,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .amber),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Expanded(
                                                            flex: 1,
                                                            child: Center(
                                                              child: Text(
                                                                "Location: ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black45),
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
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${streamSnapshot.data!.averageRating(data.ratings!, "LOCATION")}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          30,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .greenAccent),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .greenAccent,
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
                                        )
                                      : Center(
                                          child: Container(
                                            height: 100,
                                            width: 300,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: const <BoxShadow>[
                                                  BoxShadow(
                                                      blurRadius: 1.0,
                                                      blurStyle:
                                                          BlurStyle.outer,
                                                      offset: Offset(2.0, 2.0),
                                                      color: Colors.black)
                                                ]),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: FutureBuilder(
                                                    future: imageService
                                                        .getHomestayImage(data
                                                            .bloc!
                                                            .homestays!
                                                            .first
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
                                                            color:
                                                                Colors.white24,
                                                          );
                                                        case ConnectionState
                                                            .done:
                                                          final imageData =
                                                              imgSnapshot.data;
                                                          String imageUrl =
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
                                                        margin: const EdgeInsets
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
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                              utf8.decode(data
                                                                  .bloc!
                                                                  .name!
                                                                  .runes
                                                                  .toList()),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.location_on,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(utf8.decode(
                                                                data.bloc!
                                                                    .address!
                                                                    .split(",")
                                                                    .first
                                                                    .runes
                                                                    .toList()))
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .location_city,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(getCityProvinceName(
                                                                data.bloc!
                                                                    .cityProvince!,
                                                                false)!)
                                                          ],
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  !isHomestayInBloc
                                      ? Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: const [
                                                SizedBox(width: 10),
                                                Text("Homestay Feedback(s)",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 30,
                                                        color: primaryColor)),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            data.ratings!.isNotEmpty
                                                ? SizedBox(
                                                    height: 120,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child:
                                                        data.ratings!.length ==
                                                                1
                                                            ? Container(
                                                                height: 50,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10),
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            50,
                                                                        right:
                                                                            50),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(20),
                                                                    boxShadow: const <BoxShadow>[
                                                                      BoxShadow(
                                                                          blurRadius:
                                                                              1.0,
                                                                          offset: Offset(
                                                                              2.0,
                                                                              2.0),
                                                                          blurStyle:
                                                                              BlurStyle.outer)
                                                                    ]),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          FutureBuilder(
                                                                        future: imageService.getHomestayImage(data
                                                                            .ratings!
                                                                            .first
                                                                            .avatar!),
                                                                        builder:
                                                                            (context,
                                                                                imgSnapshot) {
                                                                          switch (
                                                                              snapshot.connectionState) {
                                                                            case ConnectionState.waiting:
                                                                              return Container(
                                                                                width: 450,
                                                                                height: 200,
                                                                                color: Colors.white24,
                                                                              );
                                                                            case ConnectionState.done:
                                                                              final imageData = imgSnapshot.data;
                                                                              String imageUrl = imageData ?? "https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg";
                                                                              return AdvancedAvatar(
                                                                                size: 70,
                                                                                image: NetworkImage(imageUrl),
                                                                              );
                                                                            default:
                                                                              break;
                                                                          }
                                                                          return Container(
                                                                            margin:
                                                                                const EdgeInsets.only(left: 10, right: 10),
                                                                            width:
                                                                                450,
                                                                            height:
                                                                                200,
                                                                            color:
                                                                                Colors.white24,
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            utf8.decode(data.ratings!.first.username!.runes.toList()),
                                                                            overflow:
                                                                                TextOverflow.fade,
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Row(children: [
                                                                                Text(
                                                                                  "${double.parse(data.ratings!.first.securityPoint!.toStringAsFixed(2))}",
                                                                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue, fontSize: 17),
                                                                                ),
                                                                                const Icon(
                                                                                  Icons.star,
                                                                                  color: Colors.lightBlueAccent,
                                                                                  size: 17,
                                                                                )
                                                                              ]),
                                                                              Row(children: [
                                                                                Text(
                                                                                  "${double.parse(data.ratings!.first.servicePoint!.toStringAsFixed(2))}",
                                                                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 17),
                                                                                ),
                                                                                const Icon(
                                                                                  Icons.star,
                                                                                  color: Colors.amber,
                                                                                  size: 17,
                                                                                )
                                                                              ]),
                                                                              Row(children: [
                                                                                Text(
                                                                                  "${double.parse(data.ratings!.first.locationPoint!.toStringAsFixed(2))}",
                                                                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 17),
                                                                                ),
                                                                                const Icon(
                                                                                  Icons.star,
                                                                                  color: Colors.green,
                                                                                  size: 17,
                                                                                )
                                                                              ]),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          data.ratings!.first.comment != null
                                                                              ? Text(
                                                                                  "\" ${utf8.decode(data.ratings!.first.comment!.runes.toList())} \"",
                                                                                  overflow: TextOverflow.fade,
                                                                                )
                                                                              : const Text(
                                                                                  "No comment",
                                                                                  overflow: TextOverflow.fade,
                                                                                )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            : ListView.builder(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemCount: data
                                                                    .ratings!
                                                                    .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  RatingModel
                                                                      rating =
                                                                      data.ratings![
                                                                          index];
                                                                  return Container(
                                                                    height: 50,
                                                                    width: 250,
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                        boxShadow: const <BoxShadow>[
                                                                          BoxShadow(
                                                                              blurRadius: 1.0,
                                                                              offset: Offset(2.0, 2.0),
                                                                              blurStyle: BlurStyle.outer)
                                                                        ]),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              FutureBuilder(
                                                                            future:
                                                                                imageService.getHomestayImage(rating.avatar!),
                                                                            builder:
                                                                                (context, imgSnapshot) {
                                                                              switch (snapshot.connectionState) {
                                                                                case ConnectionState.waiting:
                                                                                  return Container(
                                                                                    width: 450,
                                                                                    height: 200,
                                                                                    color: Colors.white24,
                                                                                  );
                                                                                case ConnectionState.done:
                                                                                  final imageData = imgSnapshot.data;
                                                                                  String imageUrl = imageData ?? "https://i.ytimg.com/vi/0jDUx3jOBfU/mqdefault.jpg";
                                                                                  return AdvancedAvatar(
                                                                                    size: 70,
                                                                                    image: NetworkImage(imageUrl),
                                                                                  );
                                                                                default:
                                                                                  break;
                                                                              }
                                                                              return Container(
                                                                                margin: const EdgeInsets.only(left: 10, right: 10),
                                                                                width: 450,
                                                                                height: 200,
                                                                                color: Colors.white24,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                utf8.decode(rating.username!.runes.toList()),
                                                                                overflow: TextOverflow.fade,
                                                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Row(children: [
                                                                                    Text(
                                                                                      "${double.parse(rating.securityPoint!.toStringAsFixed(2))}",
                                                                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue, fontSize: 17),
                                                                                    ),
                                                                                    const Icon(
                                                                                      Icons.star,
                                                                                      color: Colors.lightBlueAccent,
                                                                                      size: 17,
                                                                                    )
                                                                                  ]),
                                                                                  Row(children: [
                                                                                    Text(
                                                                                      "${double.parse(rating.servicePoint!.toStringAsFixed(2))}",
                                                                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 17),
                                                                                    ),
                                                                                    const Icon(
                                                                                      Icons.star,
                                                                                      color: Colors.amber,
                                                                                      size: 17,
                                                                                    )
                                                                                  ]),
                                                                                  Row(children: [
                                                                                    Text(
                                                                                      "${double.parse(rating.locationPoint!.toStringAsFixed(2))}",
                                                                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 17),
                                                                                    ),
                                                                                    const Icon(
                                                                                      Icons.star,
                                                                                      color: Colors.green,
                                                                                      size: 17,
                                                                                    )
                                                                                  ]),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 20,
                                                                              ),
                                                                              rating.comment != null
                                                                                  ? Text(
                                                                                      "\" ${utf8.decode(rating.comment!.runes.toList())} \"",
                                                                                      overflow: TextOverflow.fade,
                                                                                    )
                                                                                  : const Text(
                                                                                      "No comment",
                                                                                      overflow: TextOverflow.fade,
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
                                                            BorderRadius
                                                                .circular(20),
                                                        boxShadow: const <
                                                            BoxShadow>[
                                                          BoxShadow(
                                                              blurRadius: 1.0,
                                                              blurStyle:
                                                                  BlurStyle
                                                                      .outer,
                                                              offset: Offset(
                                                                  2.0, 2.0))
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
                                                          child: Text(
                                                              "No Feedback",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  !isHomestayInBloc
                                      ? Column(
                                          children: [
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: const [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text("Homestay Rule(s)",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 30,
                                                        color: primaryColor)),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            data.homestayRules!.isNotEmpty
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 50),
                                                    height: 37.5 *
                                                        data.homestayRules!
                                                            .length,
                                                    child: ListView.builder(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 50,
                                                              right: 50),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount: data
                                                          .homestayRules!
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        HomestayRuleModel rule =
                                                            data.homestayRules![
                                                                index];
                                                        return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 20),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  utf8.decode(rule
                                                                      .description!
                                                                      .runes
                                                                      .toList()),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              const Expanded(
                                                                flex: 1,
                                                                child: Icon(
                                                                  Icons.rule,
                                                                  color: Colors
                                                                      .green,
                                                                  size: 20,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : const Text(
                                                    "Homestay doesn't have any rule.",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Homestay Facility(s)",
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
                                    margin: const EdgeInsets.only(left: 50),
                                    height:
                                        37.5 * data.homestayFacilities!.length,
                                    child: ListView.builder(
                                      padding: const EdgeInsets.only(
                                          left: 50, right: 50),
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          data.homestayFacilities!.length,
                                      itemBuilder: (context, index) {
                                        HomestayFacilityModel fac =
                                            data.homestayFacilities![index];
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  utf8.decode(
                                                      fac.name!.runes.toList()),
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const Expanded(
                                                flex: 1,
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                  size: 20,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  !isHomestayInBloc
                                      ? Column(
                                          children: [
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: const [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text("Homestay Service(s)",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 30,
                                                        color: primaryColor)),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 37.5 *
                                                  data.homestayServices!.length,
                                              margin: const EdgeInsets.only(
                                                  left: 50),
                                              child: ListView.builder(
                                                padding: const EdgeInsets.only(
                                                    left: 50, right: 50),
                                                scrollDirection: Axis.vertical,
                                                itemCount: data
                                                    .homestayServices!.length,
                                                itemBuilder: (context, index) {
                                                  HomestayServiceModel ser =
                                                      data.homestayServices![
                                                          index];
                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            bottom: 20),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            utf8.decode(ser
                                                                .name!.runes
                                                                .toList()),
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                        )
                                      : const SizedBox(),
                                  isHomestayInBloc
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        primaryColor,
                                                    maximumSize:
                                                        const Size(200, 50),
                                                    minimumSize:
                                                        const Size(200, 50)),
                                                onPressed: () {
                                                  homestayDetailBloc
                                                      .eventController.sink
                                                      .add(ViewBlocEvent(
                                                          context: context,
                                                          blocName:
                                                              data.bloc!.name));
                                                },
                                                child: const Text("View Block",
                                                    style: TextStyle(
                                                        fontFamily: "Lobster",
                                                        fontWeight:
                                                            FontWeight.bold))),
                                          ],
                                        )
                                      : const SizedBox()
                                ]),
                              ),
                            ],
                          );
                        } else if (data is ServerExceptionModel) {
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
                        } else if (data is SocketException ||
                            data is TimeoutException) {
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
                        return AlertDialog(
                          content: const Center(
                              child: Text(
                                  "We can't get your data. Please try again later")),
                          actions: [
                            TextButton(
                                onPressed: () {},
                                child: const Text("Try again"))
                          ],
                        );
                      }
                      break;

                    default:
                      break;
                  }
                  return const SizedBox();
                },
              ),
            );
          }),
    );
  }
}
