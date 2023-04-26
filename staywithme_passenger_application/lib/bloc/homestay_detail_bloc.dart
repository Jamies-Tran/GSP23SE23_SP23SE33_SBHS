import 'dart:async';


import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/homestay_detail_event.dart';
import 'package:staywithme_passenger_application/bloc/state/homestay_detail_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_list_screen.dart';
import 'package:staywithme_passenger_application/screen/booking/choose_booking_date_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/bloc_detail_screen.dart';
import 'package:staywithme_passenger_application/screen/main_screen.dart';
import 'package:staywithme_passenger_application/service/share_preference/share_preference.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

enum HomestayType { homestay, bloc }

class HomestayDetailBloc {
  final eventController = StreamController<HomestayDetailEvent>();
  final stateController = StreamController<HomestayDetailState>();
  final _bookingService = locator.get<IBookingService>();

  String? _msg;
  Color? _msgFontColor;
  bool? _isBookingDateValid;

  HomestayDetailState iniData() =>
      HomestayDetailState(msg: null, msgFontColor: null, isBookingValid: false);

  void dispose() {
    eventController.close();
    stateController.close();
  }

  HomestayDetailBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  Future<void> eventHandler(HomestayDetailEvent event) async {
    if (event is OnCheckValidBookingDateEvent) {
      BookingValidateModel bookingValidateModel = BookingValidateModel(
          bookingEnd: event.bookingEnd,
          bookingStart: event.bookingStart,
          homestayName: event.homestayName,
          totalReservation: 0);
      await _bookingService
          .checkValidBookingDateForHomestay(bookingValidateModel)
          .then((value) {
        if (value is bool) {
          _isBookingDateValid = value;
          if (value == true) {
            _msg =
                "Homestay available from ${event.bookingStart} to ${event.bookingEnd}";
            _msgFontColor = Colors.greenAccent;
          } else {
            _msg = "Homestay has been booked";
            _msgFontColor = Colors.redAccent;
          }
        }
      });
    } else if (event is CreateBookingEvent) {
      bool isLogin = await SharedPreferencesService.isUserSignIn();
      if (isLogin == false) {
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
            title: const Center(child: Text("Notice")),
            content: const SizedBox(
                height: 200,
                width: 200,
                child: Text("You must login before taking a booking")),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No, want to look around first")),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MainScreen.mainScreenRoute,
                        arguments: {"startingIndex": 1});
                  },
                  child: const Text("Let's log in"))
            ],
          ),
        );
      } else {
        final bookingHomestayData = await _bookingService
            .getBookingHomestsayByHomestayId(event.homestay!.id!);
        if (bookingHomestayData is BookingHomestayModel) {
          showDialog(
            context: event.context!,
            builder: (context) => AlertDialog(
                title: const Center(
                  child: Text("Notice"),
                ),
                content: SizedBox(
                  width: 200,
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          "${event.homestay!.name} has been saved to your booking that haven't been submitted."),
                      const Text(
                          "Do you want to continue or start new booking?"),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, BookingLoadingScreen.bookingLoadingScreen,
                            arguments: {
                              "bookingId": bookingHomestayData
                                  .bookingHomestayId!.bookingId,
                              "homestayType": "homestay",
                            });
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(color: Colors.red),
                      )),
                  TextButton(
                      onPressed: () async {
                        await _bookingService.deleteBooking(
                            bookingHomestayData.bookingHomestayId!.bookingId!);

                        Navigator.pushNamed(
                            event.context!,
                            ChooseBookingDateForHomestayScreen
                                .chooseBookingDateForHomestayScreenRoute,
                            arguments: {
                              "homestay": event.homestay,
                              "bookingStart": event.bookingStart,
                              "bookingEnd": event.bookingEnd,
                              "brownseHomestayFlag": event.brownseHomestayFlag
                            });
                      },
                      child: const Text(
                        "Create new",
                        style: TextStyle(color: primaryColor),
                      ))
                ]),
          );
        } else {
          //   final bookingData = await _bookingService.createBooking(
          //       HomestayType.homestay.name,
          //       event.bookingStart!,
          //       event.bookingEnd!);
          //   if (bookingData is BookingModel) {
          //     Navigator.pushNamed(event.context!,
          //         BookingHomestayScreen.bookingHomestayScreenRoute,
          //         arguments: {
          //           "homestay": event.homestay,
          //           "bookingId": bookingData.id,
          //           "bookingStart": event.bookingStart,
          //           "bookingEnd": event.bookingEnd
          //         });
          //   } else if (bookingData is ServerExceptionModel) {
          //     showDialog(
          //       context: event.context!,
          //       builder: (context) => AlertDialog(
          //         title: const Center(child: Text("Notice")),
          //         content: SizedBox(
          //             height: 200,
          //             width: 200,
          //             child: Text("${bookingData.message}")),
          //         actions: [
          //           TextButton(
          //               onPressed: () {
          //                 Navigator.pop(context);
          //               },
          //               child: const Text("Cancel")),
          //         ],
          //       ),
          //     );
          //   } else if (bookingData is TimeoutException ||
          //       bookingData is SocketException) {
          //     showDialog(
          //       context: event.context!,
          //       builder: (context) => AlertDialog(
          //         title: const Center(child: Text("Notice")),
          //         content: const SizedBox(
          //             height: 200, width: 200, child: Text("Network error")),
          //         actions: [
          //           TextButton(
          //               onPressed: () {
          //                 Navigator.pop(context);
          //               },
          //               child: const Text("Cancel")),
          //         ],
          //       ),
          //     );
          //   }
          // }
          Navigator.pushNamed(
              event.context!,
              ChooseBookingDateForHomestayScreen
                  .chooseBookingDateForHomestayScreenRoute,
              arguments: {
                "homestay": event.homestay,
                "bookingStart": event.bookingStart,
                "bookingEnd": event.bookingEnd,
                "brownseHomestayFlag": event.brownseHomestayFlag
              });
        }
      }
    } else if (event is ViewBlocEvent) {
      Navigator.pushNamed(
          event.context!, BlocDetailScreen.blocDetailScreenRoute,
          arguments: {"blocName": event.blocName});
    }
    stateController.sink.add(HomestayDetailState(
        msg: _msg,
        msgFontColor: _msgFontColor,
        isBookingValid: _isBookingDateValid));
  }
}
