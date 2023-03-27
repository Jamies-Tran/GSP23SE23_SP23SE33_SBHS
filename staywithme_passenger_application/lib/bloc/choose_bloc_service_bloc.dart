import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/choose_bloc_service_event.dart';
import 'package:staywithme_passenger_application/bloc/state/choose_bloc_service_state.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/booking_bloc_screen.dart';

class ChooseBlocServiceBloc {
  final eventController = StreamController<ChooseBlocServiceEvent>();
  final stateController = StreamController<ChooseBlocServiceState>();

  final List<HomestayServiceModel> _homestayServiceList =
      <HomestayServiceModel>[];

  ChooseBlocServiceState initData() {
    return ChooseBlocServiceState(
        homestayServiceList: <HomestayServiceModel>[]);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  ChooseBlocServiceBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(ChooseBlocServiceEvent event) {
    if (event is OnChooseServiceEvent) {
      HomestayServiceModel? removeService;
      for (HomestayServiceModel service in _homestayServiceList) {
        if (service.name == event.homestayServiceModel!.name) {
          removeService = service;
        }
      }
      if (removeService != null) {
        _homestayServiceList.remove(removeService);
      } else {
        _homestayServiceList.add(event.homestayServiceModel!);
      }
    } else if (event is OnNextStepToViewHomestayInBlocFacilityEvent) {
      Navigator.pushNamed(
          event.context!, BookingBlocScreen.bookingBlocScreenRoute,
          arguments: {
            "selectedIndex": 2,
            "bookingStart": event.bookingStart,
            "bookingEnd": event.bookingEnd,
            "bookingBlocList": event.bookingBlocList,
            "blocServiceList": event.blocServiceList,
            "bloc": event.bloc,
            "bookingId": event.bookingId,
            "totalHomestayPrice": event.totalHomestayPrice,
            "totalServicePrice": event.totalServicePrice,
          });
    }

    stateController.sink
        .add(ChooseBlocServiceState(homestayServiceList: _homestayServiceList));
  }
}
