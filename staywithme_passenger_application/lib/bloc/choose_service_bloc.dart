import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/choose_service_event.dart';
import 'package:staywithme_passenger_application/bloc/state/choose_service_state.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_homestay_screen.dart';

class ChooseHomestayServiceBloc {
  final eventController = StreamController<ChooseServiceEvent>();
  final stateController = StreamController<ChooseServiceState>();

  final List<HomestayServiceModel> _homestayServiceList = [];

  ChooseServiceState initData() {
    return ChooseServiceState(homestayServiceList: <HomestayServiceModel>[]);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  ChooseHomestayServiceBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(ChooseServiceEvent event) {
    if (event is OnTabHomestayServiceEvent) {
      HomestayServiceModel? removeService;
      for (HomestayServiceModel homestayServiceModel in _homestayServiceList) {
        if (event.homestayServiceModel!.name == homestayServiceModel.name) {
          removeService = homestayServiceModel;
        }
      }
      if (removeService != null) {
        _homestayServiceList.remove(removeService);
      } else {
        _homestayServiceList.add(event.homestayServiceModel!);
      }
    } else if (event is OnNextStepToOverviewBookingHomestayEvent) {
      Navigator.pushNamed(
          event.context!, BookingHomestayScreen.bookingHomestayScreenRoute,
          arguments: {
            "selectedIndex": 3,
            "homestay": event.homestay,
            "bookingId": event.bookingId,
            "homestayServiceList": event.homestayServiceList,
            "totalServicePrice": event.totalServicePrice,
            "bookingStart": event.bookingStart,
            "bookingEnd": event.bookingEnd
          });
    }

    stateController.sink
        .add(ChooseServiceState(homestayServiceList: _homestayServiceList));
  }
}
