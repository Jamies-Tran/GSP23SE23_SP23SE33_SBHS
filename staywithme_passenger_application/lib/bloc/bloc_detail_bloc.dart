import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/bloc_detail_event.dart';
import 'package:staywithme_passenger_application/bloc/state/bloc_detail_state.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/screen/booking/choose_booking_date_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/homestay_detail_screen.dart';
import 'package:staywithme_passenger_application/screen/main_screen.dart';
import 'package:staywithme_passenger_application/service/share_preference/share_preference.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class BlocHomestayDetailBloc {
  final eventController = StreamController<BlocHomestayDetailEvent>();
  final stateController = StreamController<BlocHomestayDetailState>();

  final _bookingService = locator.get<IBookingService>();
  final _firebaseAuth = FirebaseAuth.instance;

  BlocBookingDateValidationModel? _blocBookingDateValidation;
  String? _msg;
  Color? _msgFontColor;
  bool? _isBookingValid;
  String? _name;

  BlocHomestayDetailState initData(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    _name = contextArguments["blocName"];
    return BlocHomestayDetailState(
        name: contextArguments["blocName"],
        msg: null,
        msgFontColor: null,
        isBookingValid: false,
        blocBookingDateValidation: null);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  BlocHomestayDetailBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  Future<void> eventHandler(BlocHomestayDetailEvent event) async {
    if (event is ChooseBookingDateForBlocEvent) {
      final isSignIn = await SharedPreferencesService.isUserSignIn();
      if (isSignIn) {
        Navigator.pushNamed(
            event.context!,
            ChooseBookingDateForBlocHomestayScreen
                .chooseBookingDateForBlocHomestayScreenRoute,
            arguments: {"bloc": event.bloc});
      } else {
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
      }
    } else if (event is CreateBookingEvent) {
      if (_firebaseAuth.currentUser == null) {
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
        // final bookingData =
        //     await _bookingService.getBookingSavedBlocHomestayType();
        // if (bookingData is BookingModel) {
        //   final bookingValidationModel = BookingValidateModel(
        //       bookingStart: event.bookingStart,
        //       bookingEnd: event.bookingEnd,
        //       homestayName: event.bloc!.name);
        //   BlocBookingDateValidationModel blocBookingValidation =
        //       await _bookingService
        //           .getBlocAvailableHomestayList(bookingValidationModel);
        //   showDialog(
        //     context: event.context!,
        //     builder: (context) => AlertDialog(
        //       title: const Center(child: Text("Notice")),
        //       content: SizedBox(
        //         width: 50,
        //         height: 100,
        //         child: Column(children: const [
        //           Text(
        //               "You already have a booking for block homestay that haven't been submitted"),
        //           Text(
        //               "Do you want to continue with that booking or create new?")
        //         ]),
        //       ),
        //       actions: [
        //         TextButton(
        //             onPressed: () {
        //               Navigator.pushNamed(
        //                   context, BookingLoadingScreen.bookingLoadingScreen,
        //                   arguments: {
        //                     "bookingId": bookingData.id,
        //                     "homestayType": bookingData.homestayType,
        //                     "blocBookingValidation": blocBookingValidation
        //                   });
        //             },
        //             child: const Text(
        //               "Continue",
        //               style: TextStyle(
        //                   fontWeight: FontWeight.bold, color: secondaryColor),
        //             )),
        //         TextButton(
        //             onPressed: () async {
        //               await _bookingService.deleteBooking(bookingData.id!);
        //               final createBookingData =
        //                   await _bookingService.createBooking(
        //                       HomestayType.bloc.name,
        //                       event.bookingStart!,
        //                       event.bookingEnd!);
        //               if (createBookingData is BookingModel) {
        //                 Navigator.pushNamed(event.context!,
        //                     BookingBlocScreen.bookingBlocScreenRoute,
        //                     arguments: {
        //                       "bloc": event.bloc,
        //                       "blocBookingValidation": blocBookingValidation,
        //                       "bookingId": createBookingData.id,
        //                       "bookingStart": event.bookingStart,
        //                       "bookingEnd": event.bookingEnd
        //                     });
        //               } else if (createBookingData is ServerExceptionModel) {
        //                 showDialog(
        //                   context: event.context!,
        //                   builder: (context) => AlertDialog(
        //                     title: const Center(child: Text("Notice")),
        //                     content: SizedBox(
        //                         height: 200,
        //                         width: 200,
        //                         child: Text("${createBookingData.message}")),
        //                     actions: [
        //                       TextButton(
        //                           onPressed: () {
        //                             Navigator.pop(context);
        //                           },
        //                           child: const Text("Cancel")),
        //                     ],
        //                   ),
        //                 );
        //               } else if (createBookingData is TimeoutException ||
        //                   createBookingData is SocketException) {
        //                 showDialog(
        //                   context: event.context!,
        //                   builder: (context) => AlertDialog(
        //                     title: const Center(child: Text("Notice")),
        //                     content: const SizedBox(
        //                         height: 200,
        //                         width: 200,
        //                         child: Text("Network error")),
        //                     actions: [
        //                       TextButton(
        //                           onPressed: () {
        //                             Navigator.pop(context);
        //                           },
        //                           child: const Text("Cancel")),
        //                     ],
        //                   ),
        //                 );
        //               }
        //             },
        //             child: const Text(
        //               "Create new",
        //               style: TextStyle(
        //                   fontWeight: FontWeight.bold, color: primaryColor),
        //             ))
        //       ],
        //     ),
        //   );
        // } else if (bookingData is ServerExceptionModel) {
        //   if (bookingData.statusCode == 404) {
        //     final createBookingData = await _bookingService.createBooking(
        //         HomestayType.bloc.name, event.bookingStart!, event.bookingEnd!);
        //     if (createBookingData is BookingModel) {
        //       Navigator.pushNamed(
        //           event.context!, BookingBlocScreen.bookingBlocScreenRoute,
        //           arguments: {
        //             "bloc": event.bloc,
        //             "blocBookingValidation": event.blocBookingDateValidation,
        //             "bookingId": createBookingData.id,
        //             "bookingStart": event.bookingStart,
        //             "bookingEnd": event.bookingEnd
        //           });
        //     } else if (createBookingData is ServerExceptionModel) {
        //       showDialog(
        //         context: event.context!,
        //         builder: (context) => AlertDialog(
        //           title: const Center(child: Text("Notice")),
        //           content: SizedBox(
        //               height: 200,
        //               width: 200,
        //               child: Text("${createBookingData.message}")),
        //           actions: [
        //             TextButton(
        //                 onPressed: () {
        //                   Navigator.pop(context);
        //                 },
        //                 child: const Text("Cancel")),
        //           ],
        //         ),
        //       );
        //     } else if (createBookingData is TimeoutException ||
        //         createBookingData is SocketException) {
        //       showDialog(
        //         context: event.context!,
        //         builder: (context) => AlertDialog(
        //           title: const Center(child: Text("Notice")),
        //           content: const SizedBox(
        //               height: 200, width: 200, child: Text("Network error")),
        //           actions: [
        //             TextButton(
        //                 onPressed: () {
        //                   Navigator.pop(context);
        //                 },
        //                 child: const Text("Cancel")),
        //           ],
        //         ),
        //       );
        //     }
        //   }
        // }
      }
    } else if (event is ViewHomestayEvent) {
      Navigator.pushNamed(
          event.context!, HomestayDetailScreen.homestayDetailScreenRoute,
          arguments: {
            "homestayName": event.homestayName,
            "isHomestayInBloc": true
          });
    }
    stateController.sink.add(BlocHomestayDetailState(
        name: _name,
        msg: _msg,
        msgFontColor: _msgFontColor,
        isBookingValid: _isBookingValid,
        blocBookingDateValidation: _blocBookingDateValidation));
  }
}
