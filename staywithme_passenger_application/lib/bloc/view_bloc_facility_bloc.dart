import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/view_bloc_facility_event.dart';
import 'package:staywithme_passenger_application/bloc/state/view_bloc_facility_state.dart';
import 'package:staywithme_passenger_application/screen/homestay/booking_bloc_screen.dart';

class ViewHomestayInBlocFacilityBloc {
  final eventController = StreamController<ViewHomestayInBlocFacilityEvent>();
  final stateController = StreamController<ViewHomestayInBlocFacilityState>();

  int _index = 0;

  ViewHomestayInBlocFacilityState initData() {
    return ViewHomestayInBlocFacilityState(selectedIndex: 0);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  ViewHomestayInBlocFacilityBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(ViewHomestayInBlocFacilityEvent event) {
    if (event is SelectHomestayInBlocEvent) {
      if (event.isNext!) {
        if (event.totalHomestays! > event.currentIndex!) {
          _index = event.currentIndex! + 1;
        }
      } else {
        if (event.currentIndex! > 0) {
          _index = event.currentIndex! - 1;
        }
      }
    } else if (event is OnNextStepToBlocRuleEvent) {
      Navigator.pushNamed(
          event.context!, BookingBlocScreen.bookingBlocScreenRoute,
          arguments: {
            "selectedIndex": 1,
            "bookingStart": event.bookingStart,
            "bookingEnd": event.bookingEnd,
            "blocBookingValidation": event.blocBookingvalidation,
            "bookingBlocList": event.bookingBlocList,
            "blocServiceList": event.blocServiceList,
            "bloc": event.bloc,
            "bookingId": event.bookingId,
            "totalHomestayPrice": event.totalHomestayPrice,
            "totalServicePrice": event.totalServicePrice
          });
    }
    stateController.sink
        .add(ViewHomestayInBlocFacilityState(selectedIndex: _index));
  }
}
