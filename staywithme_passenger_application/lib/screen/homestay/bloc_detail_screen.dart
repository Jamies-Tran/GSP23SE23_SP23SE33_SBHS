import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/bloc_detail_bloc.dart';
import 'package:staywithme_passenger_application/bloc/event/bloc_detail_event.dart';
import 'package:staywithme_passenger_application/bloc/state/bloc_detail_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
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
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      blocData.name!,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Lobster",
                                          color: primaryColor),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: TextFormField(
                                            controller:
                                                bookingStartDateTextEditingController,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Start date yyyy-MM-dd",
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                secondaryColor,
                                                            width: 1.0)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                secondaryColor,
                                                            width: 1.0))),
                                            onTap: () {
                                              showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime.now()
                                                          .add(const Duration(
                                                              days: 365)))
                                                  .then((value) {
                                                bookingStartDateTextEditingController
                                                        .text =
                                                    dateFormat.format(value!);
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextFormField(
                                            controller:
                                                bookingEndDateTextEditingController,
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                              hintText: "End date yyyy-MM-dd",
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor,
                                                      width: 1.0)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor,
                                                      width: 1.0)),
                                            ),
                                            onTap: () {
                                              showDatePicker(
                                                      context: context,
                                                      initialDate: dateFormat
                                                          .parse(
                                                              bookingStartDateTextEditingController
                                                                  .text)
                                                          .add(const Duration(
                                                              days: 1)),
                                                      firstDate: dateFormat
                                                          .parse(
                                                              bookingStartDateTextEditingController
                                                                  .text)
                                                          .add(const Duration(
                                                              days: 1)),
                                                      lastDate: dateFormat
                                                          .parse(
                                                              bookingStartDateTextEditingController
                                                                  .text)
                                                          .add(const Duration(
                                                              days: 365)))
                                                  .then((value) {
                                                bookingEndDateTextEditingController
                                                        .text =
                                                    dateFormat.format(value!);
                                                blocHomestayDetailBloc
                                                    .eventController.sink
                                                    .add(OnGetBlocAvailableHomestayListEvent(
                                                        bookingStart:
                                                            bookingStartDateTextEditingController
                                                                .text,
                                                        bookingEnd:
                                                            bookingEndDateTextEditingController
                                                                .text,
                                                        blocName:
                                                            blocData.name));
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    streamSnapshot.data!.msg != null
                                        ? Text(
                                            streamSnapshot.data!.msg!,
                                            style: TextStyle(
                                                color: streamSnapshot
                                                    .data!.msgFontColor),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(200, 50),
                                              maximumSize: const Size(200, 50),
                                              backgroundColor: streamSnapshot
                                                          .data!
                                                          .isBookingValid ==
                                                      true
                                                  ? primaryColor
                                                  : Colors.grey),
                                          onPressed: () {
                                            if (streamSnapshot
                                                    .data!.isBookingValid ==
                                                true) {
                                              blocHomestayDetailBloc
                                                  .eventController.sink
                                                  .add(CreateBookingEvent(
                                                      context: context,
                                                      bloc: blocData,
                                                      blocBookingDateValidation:
                                                          streamSnapshot.data!
                                                              .blocBookingDateValidation,
                                                      bookingStart:
                                                          bookingStartDateTextEditingController
                                                              .text,
                                                      bookingEnd:
                                                          bookingEndDateTextEditingController
                                                              .text));
                                              // homestayDetailBloc
                                              //     .eventController.sink
                                              //     .add(CreateBookingEvent(
                                              //         context: context,
                                              //         homestayName: data.name,
                                              //         homestayId: data.id,
                                              //         bookingStart:
                                              //             bookingStartDateTextEditingController
                                              //                 .text,
                                              //         bookingEnd:
                                              //             bookingEndDateTextEditingController
                                              //                 .text));
                                            }
                                          },
                                          child: const Text(
                                            "Book",
                                            style: TextStyle(
                                                fontFamily: "Lobster",
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  ],
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
