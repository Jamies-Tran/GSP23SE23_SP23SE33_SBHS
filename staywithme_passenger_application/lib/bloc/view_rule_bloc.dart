import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/view_rule_event.dart';
import 'package:staywithme_passenger_application/screen/homestay/booking_homestay_screen.dart';

class ViewHomestayRuleBloc {
  final eventController = StreamController<ViewHomestayRuleEvent>();

  void dispose() {
    eventController.close();
  }

  ViewHomestayRuleBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(ViewHomestayRuleEvent event) {
    if (event is OnNextStepToOverviewEvent) {
      Navigator.pushNamed(
          event.context!, BookingHomestayScreen.bookingHomestayScreenRoute,
          arguments: {
            "selectedIndex": 3,
            "homestay": event.homestay,
            "bookingId": event.bookingId,
            "bookingStart": event.bookingStart,
            "bookingEnd": event.bookingEnd,
            "homestayServiceList": event.homestayServiceList,
            "totalServicePrice": event.totalServicePrice
          });
    }
  }
}
