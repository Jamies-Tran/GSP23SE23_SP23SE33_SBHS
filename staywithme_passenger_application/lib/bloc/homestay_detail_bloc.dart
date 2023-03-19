import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/homestay_detail_event.dart';
import 'package:staywithme_passenger_application/bloc/state/homestay_detail_state.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class HomestayDetailBloc {
  final eventController = StreamController<HomestayDetailEvent>();
  final stateController = StreamController<HomestayDetailState>();
  final bookingService = locator.get<IBookingService>();

  String? _msg;
  Color? _msgFontColor;

  HomestayDetailState iniData() =>
      HomestayDetailState(msg: null, msgFontColor: null);

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
      await bookingService
          .checkValidBookingDateForHomestay(bookingValidateModel)
          .then((value) {
        if (value is bool) {
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
    }
    stateController.sink
        .add(HomestayDetailState(msg: _msg, msgFontColor: _msgFontColor));
  }
}
