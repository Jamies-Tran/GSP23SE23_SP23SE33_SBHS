import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/overview_booking_event.dart';
import 'package:staywithme_passenger_application/bloc/state/overview_booking_state.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/booking_homestay_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/process_booking_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/search_homestay_screen.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class OverviewBookingBloc {
  final eventController = StreamController<OverviewBookingEvent>();
  final stateController = StreamController<OverviewBookingState>();
  final bookingService = locator.get<IBookingService>();
  final firebaseAuth = FirebaseAuth.instance;

  PaymentMethod _paymentMethod = PaymentMethod.cash;
  HomestayModel? _homestay;
  String? _bookingStart;
  String? _bookingEnd;
  List<HomestayServiceModel>? _homestayServiceList = <HomestayServiceModel>[];
  int? _totalServicePrice;

  OverviewBookingState initData(
      HomestayModel homestay,
      String bookingStart,
      String bookingEnd,
      int totalReservation,
      List<HomestayServiceModel> homestayServiceList,
      int totalServicePrice) {
    _homestay = homestay;
    _bookingStart = bookingStart;
    _bookingEnd = bookingEnd;
    _homestayServiceList = homestayServiceList;
    _totalServicePrice = totalServicePrice;
    return OverviewBookingState(
        bookingStart: bookingStart,
        bookingEnd: bookingEnd,
        totalReservation: totalReservation,
        homestay: homestay,
        homestayServiceList: homestayServiceList,
        totalServicePrice: totalServicePrice,
        paymentMethod: _paymentMethod);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  OverviewBookingBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  Future<void> eventHandler(OverviewBookingEvent event) async {
    if (event is ChoosePaymentMethodEvent) {
      _paymentMethod = event.paymentMethod!;
    } else if (event is EditHomestayServiceBookingEvent) {
      Navigator.pushNamed(
          event.conext!, BookingHomestayScreen.bookingHomestayScreenRoute,
          arguments: {
            "selectedIndex": 0,
            "homestayServiceList": event.homestayServiceList,
            "homestayName": event.homestayName,
            "bookingStart": event.bookingStart,
            "bookingEnd": event.bookingEnd,
            "totalServicePrice": event.totalServicePrice
          });
    } else if (event is SaveBookingHomestayEvent) {
      final bookingHomestayData =
          await bookingService.saveHomestayForBooking(event.bookingHomestay!);
      if (bookingHomestayData is BookingHomestayModel) {
        showDialog(
            context: event.context!,
            builder: (context) => AlertDialog(
                    title: const Center(
                      child: Text("Notice"),
                    ),
                    content: const SizedBox(
                      height: 200,
                      width: 200,
                      child: Text("Do you want to keep on booking?"),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context,
                                ProcessBookingScreen.processBookingScreenRoute,
                                arguments: {"bookingId": event.bookingId});
                          },
                          child: const Text(
                            "No, that's all for now",
                            style: TextStyle(
                                fontSize: 15, color: Colors.greenAccent),
                          )),
                      TextButton(
                          onPressed: () {
                            FilterByBookingDate filterByBookingDate =
                                FilterByBookingDate(
                                    start: event.bookingHomestay!.bookingFrom,
                                    end: event.bookingHomestay!.bookingTo,
                                    totalReservation: event.bookingHomestay!
                                        .homestay!.availableRooms);
                            FilterByAddress filterByAddress = FilterByAddress(
                                address: utf8.decode(event
                                    .bookingHomestay!.homestay!.address!.runes
                                    .toList()),
                                distance: 5000,
                                isGeometry: true);
                            FilterOptionModel filterOptionModel =
                                FilterOptionModel(
                                    filterByBookingDateRange:
                                        filterByBookingDate,
                                    filterByAddress: filterByAddress);
                            Navigator.pushReplacementNamed(context,
                                SearchHomestayScreen.searchHomestayScreenRoute,
                                arguments: {
                                  "filterOption": filterOptionModel,
                                  "homestayType": "homestay"
                                });
                          },
                          child: const Text(
                            "Yes, i want to look around for more",
                            style: TextStyle(
                                fontSize: 15, color: Colors.greenAccent),
                          ))
                    ]),
            barrierDismissible: false);
      } else if (bookingHomestayData is ServerExceptionModel) {
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
              title: const Center(
                child: Text("Notice"),
              ),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: 200,
                  height: 150,
                  margin: const EdgeInsets.all(20),
                  child: Text(bookingHomestayData.message!),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"))
              ]),
        );
      } else if (bookingHomestayData is SocketException ||
          bookingHomestayData is TimeoutException) {
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
              title: const Center(
                child: Text("Notice"),
              ),
              content: Container(
                width: 200,
                height: 150,
                margin: const EdgeInsets.all(20),
                child: const Text("Unable to connect to server"),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"))
              ]),
        );
      }
    }

    stateController.sink.add(OverviewBookingState(
        homestay: _homestay,
        bookingStart: _bookingStart,
        bookingEnd: _bookingEnd,
        homestayServiceList: _homestayServiceList,
        paymentMethod: _paymentMethod,
        totalServicePrice: _totalServicePrice));
  }
}
