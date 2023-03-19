import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final firebaseAuth = FirebaseAuth.instance;
  final homestayService = locator.get<IHomestayService>();
  final imageService = locator.get<IImageService>();
  final homestayDetailBloc = HomestayDetailBloc();

  @override
  Widget build(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    String homestayName = contextArguments["homestayName"];
    final bookingStartDateTextEditingController = TextEditingController();
    final bookingEndDateTextEditingController = TextEditingController();

    return Scaffold(
      backgroundColor: primaryColor,
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
                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(children: [
                              SizedBox(
                                height: 200,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: FutureBuilder(
                                        future: imageService.getHomestayImage(
                                            data.homestayImages!.first
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
                                                    right: 225),
                                                child: Opacity(
                                                  opacity: 0.5,
                                                  child: Container(
                                                    color: Colors.black,
                                                    child: Center(
                                                      child: Text(
                                                        "+${data.homestayImages!.length} more",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25),
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
                                      data.name!,
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
                                                homestayDetailBloc
                                                    .eventController.sink
                                                    .add(OnCheckValidBookingDateEvent(
                                                        bookingStart:
                                                            bookingStartDateTextEditingController
                                                                .text,
                                                        bookingEnd:
                                                            bookingEndDateTextEditingController
                                                                .text,
                                                        homestayName:
                                                            data.name));
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
                                        : const SizedBox()
                                  ],
                                ),
                              )
                            ]),
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
