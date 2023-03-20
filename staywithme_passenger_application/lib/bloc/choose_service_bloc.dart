import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/choose_service_event.dart';
import 'package:staywithme_passenger_application/bloc/state/choose_service_state.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/booking_homestay_screen.dart';

class ChooseHomestayServiceBloc {
  final eventController = StreamController<ChooseServiceEvent>();
  final stateController = StreamController<ChooseServiceState>();

  ChooseServiceState initData() => ChooseServiceState(homestayServiceList: []);
  List<HomestayServiceModel> _homestayServiceList = [];

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
    } else if (event is OnNextStepToHomestayFacilityEvent) {
      Navigator.pushNamed(
          event.context!, BookingHomestayScreen.bookingHomestayScreenRoute,
          arguments: {
            "selectedIndex": 1,
            "homestayName": event.homestayName,
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
