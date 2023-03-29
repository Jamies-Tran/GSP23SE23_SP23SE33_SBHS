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

  ChooseBlocServiceState initData(List<HomestayServiceModel>? blocServiceList) {
    return ChooseBlocServiceState(
      homestayServiceList: blocServiceList ?? <HomestayServiceModel>[],
    );
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
    } else if (event is OnNextStepToOviewBlocBookingEvent) {
      if (event.overviewFlag == true) {
        Navigator.pushNamed(
            event.context!, BookingBlocScreen.bookingBlocScreenRoute,
            arguments: {
              "selectedIndex": 4,
              "bookingStart": event.bookingStart,
              "bookingEnd": event.bookingEnd,
              "blocBookingValidation": event.blocBookingValidation,
              "bookingBlocList": event.bookingBlocList,
              "blocServiceList": event.blocServiceList,
              "bloc": event.bloc,
              "bookingId": event.bookingId,
              "totalHomestayPrice": event.totalHomestayPrice,
              "totalServicePrice": event.totalServicePrice,
            });
      } else {
        Navigator.pushNamed(
            event.context!, BookingBlocScreen.bookingBlocScreenRoute,
            arguments: {
              "selectedIndex": 4,
              "bookingStart": event.bookingStart,
              "bookingEnd": event.bookingEnd,
              "blocBookingValidation": event.blocBookingValidation,
              "bookingBlocList": event.bookingBlocList,
              "blocServiceList": event.blocServiceList,
              "bloc": event.bloc,
              "bookingId": event.bookingId,
              "totalHomestayPrice": event.totalHomestayPrice,
              "totalServicePrice": event.totalServicePrice,
            });
      }
    }

    stateController.sink
        .add(ChooseBlocServiceState(homestayServiceList: _homestayServiceList));
  }
}
