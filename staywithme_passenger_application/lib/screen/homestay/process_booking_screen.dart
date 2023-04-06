import 'dart:async';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/bloc/process_booking_bloc.dart';
import 'package:staywithme_passenger_application/bloc/state/process_booking_event.dart';
import 'package:staywithme_passenger_application/bloc/state/process_booking_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_screen.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class ProcessBookingScreen extends StatefulWidget {
  const ProcessBookingScreen({super.key});
  static const processBookingScreenRoute = "/process-booking";

  @override
  State<ProcessBookingScreen> createState() => _ProcessBookingScreenState();
}

class _ProcessBookingScreenState extends State<ProcessBookingScreen> {
  final processBookingBloc = ProcessBookingBloc();
  final bookingService = locator.get<IBookingService>();
  final firebaseAuth = FirebaseAuth.instance;

  @override
  void dispose() {
    processBookingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProcessBookingState>(
      stream: processBookingBloc.stateController.stream,
      initialData: processBookingBloc.initData(context),
      builder: (context, streamSnapshot) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            body: Container(
              color: primaryColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: streamSnapshot.data!.homestayType ==
                      HomestayType.homestay.name
                  ? FutureBuilder(
                      future: bookingService.submitBookingHomestay(
                          streamSnapshot.data!.bookingId!),
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
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    "Processing your booking, please wait a minute...")
                              ],
                            );
                          case ConnectionState.done:
                            if (snapshot.hasData) {
                              final bookingData = snapshot.data;
                              if (bookingData is BookingModel) {
                                processBookingBloc.eventController.sink.add(
                                    SuccessProcessBookingEvent(
                                        context: context));
                              } else if (bookingData is ServerExceptionModel) {
                                return AlertDialog(
                                  title: const Center(child: Text("Notice")),
                                  content: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Text(bookingData.message!),
                                  ),
                                );
                              } else if (bookingData is TimeoutException ||
                                  bookingData is SocketException) {
                                return const AlertDialog(
                                  title: Center(child: Text("Notice")),
                                  content: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Text("Coudn't connect to server"),
                                  ),
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
                    )
                  : FutureBuilder(
                      future: bookingService.submitBookingBloc(
                          streamSnapshot.data!.bookingId!,
                          streamSnapshot.data!.paymentMethod!),
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
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    "Processing your booking, please wait a minute...")
                              ],
                            );
                          case ConnectionState.done:
                            if (snapshot.hasData) {
                              final bookingData = snapshot.data;
                              if (bookingData is BookingModel) {
                                processBookingBloc.eventController.sink.add(
                                    SuccessProcessBookingEvent(
                                        context: context));
                              } else if (bookingData is ServerExceptionModel) {
                                return AlertDialog(
                                  title: const Center(child: Text("Notice")),
                                  content: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Text(bookingData.message!),
                                  ),
                                );
                              } else if (bookingData is TimeoutException ||
                                  bookingData is SocketException) {
                                return const AlertDialog(
                                  title: Center(child: Text("Notice")),
                                  content: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Text("Coudn't connect to server"),
                                  ),
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
            ),
          ),
        );
      },
    );
  }
}
