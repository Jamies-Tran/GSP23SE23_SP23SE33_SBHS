import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/state/process_booking_event.dart';
import 'package:staywithme_passenger_application/bloc/state/process_booking_state.dart';
import 'package:staywithme_passenger_application/screen/main_screen.dart';

class ProcessBookingBloc {
  final eventController = StreamController<ProcessBookingEvent>();
  final stateController = StreamController<ProcessBookingState>();

  String? _paymentMethod;
  String? _homestayType;

  ProcessBookingState initData(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    _paymentMethod = contextArguments["paymentMethod"];
    _homestayType = contextArguments["homestayType"];
    return ProcessBookingState(
        bookingId: contextArguments["bookingId"],
        homestayType: contextArguments["homestayType"],
        paymentMethod: contextArguments["paymentMethod"]);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  ProcessBookingBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(ProcessBookingEvent event) {
    if (event is SuccessProcessBookingEvent) {
      Navigator.pushReplacementNamed(event.context!, MainScreen.mainScreenRoute,
          arguments: {"selectedIndex": 0});
    }
  }
}
