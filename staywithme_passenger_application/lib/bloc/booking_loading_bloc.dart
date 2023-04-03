import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/booking_loading_event.dart';
import 'package:staywithme_passenger_application/bloc/state/booking_loading_state.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_list_screen.dart';

class BookingLoadingBloc {
  final eventController = StreamController<BookingLoadingEvent>();
  final stateController = StreamController<BookingLoadingState>();

  int? _bookingId;
  String? _homestayType;

  BookingLoadingState initData(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    _bookingId = contextArguments["bookingId"];
    _homestayType = contextArguments["homestayType"];
    return BookingLoadingState(
        bookingId: contextArguments["bookingId"],
        homestayType: contextArguments["homestayType"]);
  }

  BookingLoadingBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(BookingLoadingEvent event) {
    if (event is GetBookingSuccessEvent) {
      Navigator.pushReplacementNamed(
          event.context!, BookingListScreen.bookingListScreenRoute, arguments: {
        "booking": event.booking,
        "homestayType": event.homestayType
      });
    }
    stateController.sink.add(BookingLoadingState(
        bookingId: _bookingId, homestayType: _homestayType));
  }
}
