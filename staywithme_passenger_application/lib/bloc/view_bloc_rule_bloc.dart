import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/view_bloc_rule_event.dart';
import 'package:staywithme_passenger_application/screen/homestay/booking_bloc_screen.dart';

class ViewBlocHomestayRuleBloc {
  final eventController = StreamController<ViewBlocHomestayRuleEvent>();

  void dispose() {
    eventController.close();
  }

  ViewBlocHomestayRuleBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(ViewBlocHomestayRuleEvent event) {
    if (event is OnNextStepToChooseHomestayInBlocEvent) {
      Navigator.pushNamed(
          event.context!, BookingBlocScreen.bookingBlocScreenRoute,
          arguments: {
            "selectedIndex": 2,
            "bookingStart": event.bookingStart,
            "bookingEnd": event.bookingEnd,
            "blocBookingValidation": event.blocBookingValidation,
            "bookingBlocList": event.bookingBlocList,
            "blocServiceList": event.blocServiceList,
            "bloc": event.bloc,
            "bookingId": event.bookingId,
            "totalHomestayPrice": event.totalHomestayPrice,
          });
    }
  }
}
