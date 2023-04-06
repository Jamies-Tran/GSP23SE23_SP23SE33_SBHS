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
  bool? _isBookingHomestay;
  int? _bookingHomestayIndex;

  BookingLoadingBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(BookingLoadingEvent event) {
    if (event is GetBookingSuccessEvent) {
      Navigator.pushReplacementNamed(
          event.context!, BookingListScreen.bookingListScreenRoute,
          arguments: {
            "booking": event.booking,
            "homestayType": event.homestayType,
            "bookingHomestayIndex": event.bookingHomestayIndex,
            "isBookingHomestay": event.isBookingHomestay,
            "blocBookingValidation": event.blocBookingValidation
          });
    }
    stateController.sink.add(BookingLoadingState(
        bookingId: _bookingId,
        homestayType: _homestayType,
        bookingHomestayIndex: _bookingHomestayIndex,
        isBookingHomestay: _isBookingHomestay));
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }
}
