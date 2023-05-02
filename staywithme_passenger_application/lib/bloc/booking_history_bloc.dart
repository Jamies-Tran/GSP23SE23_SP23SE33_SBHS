import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/booking_history_event.dart';
import 'package:staywithme_passenger_application/bloc/state/booking_history_state.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_list_screen.dart';

class BookingHistoryBloc {
  final eventController = StreamController<BookingHistoryEvent>();
  final stateController = StreamController<BookingHistoryState>();

  String? _homestayType = "Homestay";
  String? _status = "All";
  bool? _isHost = true;

  BookingHistoryState initData() => BookingHistoryState(
      homestayType: "Homestay", isHost: true, status: "All");

  void dispose() {
    eventController.close();
    stateController.close();
  }

  BookingHistoryBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(BookingHistoryEvent event) {
    if (event is ChooseHomestayTypeEvent) {
      _homestayType = event.homestayType;
    } else if (event is ChooseHomestayStatusEvent) {
      _status = event.status;
    } else if (event is ChooseHostOrGuestHomestayEvent) {
      _isHost = event.isHost;
    } else if (event is ViewBookingDetailEvent) {
      Navigator.pushNamed(
          event.context!, BookingLoadingScreen.bookingLoadingScreen,
          arguments: {
            "bookingId": event.bookingId,
            "homestayType": event.homestayType,
            "viewDetail": true,
            "isHost": _isHost
          });
    }
    stateController.sink.add(BookingHistoryState(
        homestayType: _homestayType, isHost: _isHost, status: _status));
  }
}
