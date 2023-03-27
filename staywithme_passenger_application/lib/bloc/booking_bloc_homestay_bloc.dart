import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/state/booking_bloc_state.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

class BookingBlocHomestayBloc {
  final stateController = StreamController<BookingBlocHomestayState>();

  BookingBlocHomestayState initData(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    return BookingBlocHomestayState(
        bloc: contextArguments["bloc"],
        bookingId: contextArguments["bookingId"],
        bookingStart: contextArguments["bookingStart"],
        bookingEnd: contextArguments["bookingEnd"],
        selectedIndex: contextArguments["selectedIndex"] ?? 0,
        blocBookingDateValidation:
            contextArguments["blocBookingDateValidation"],
        blocServiceList:
            contextArguments["blocServiceList"] ?? <HomestayServiceModel>[],
        bookingBlocList:
            contextArguments["bookingBlocList"] ?? <BookingBlocModel>[],
        totalHomestayPrice: contextArguments["totalHomestayPrice"] ?? 0,
        totalServicePrice: contextArguments["totalServicePrice"] ?? 0);
  }

  void dispose() {
    stateController.close();
  }

  BookingBlocHomestayBloc();
}
