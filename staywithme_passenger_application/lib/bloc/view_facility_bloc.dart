import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:staywithme_passenger_application/bloc/event/view_facility_event.dart';
import 'package:staywithme_passenger_application/screen/homestay/booking_homestay_screen.dart';

class ViewHomestayFacilityBloc {
  final eventController = StreamController<ViewHomestayFacilityEvent>();

  void dispose() {
    eventController.close();
  }

  ViewHomestayFacilityBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(ViewHomestayFacilityEvent event) {
    if (event is OnNextStepToHomestayRuleEvent) {
      Navigator.pushNamed(
          event.context!, BookingHomestayScreen.bookingHomestayScreenRoute,
          arguments: {
            "selectedIndex": 1,
            "homestay": event.homestay,
            "bookingId": event.bookingId,
            "bookingStart": event.bookingStart,
            "bookingEnd": event.bookingEnd,
          });
    }
  }
}
