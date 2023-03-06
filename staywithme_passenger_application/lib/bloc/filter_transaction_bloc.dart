import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/filter_transaction_event.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_screen.dart';

class FilterTransactionBloc {
  final eventController = StreamController<FilterTransactionEvent>();

  void dispose() {
    eventController.close();
  }

  FilterTransactionBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(FilterTransactionEvent event) {
    if (event is FinishGetFilterAdditionalHomestayEvent) {
      Navigator.pushReplacementNamed(
          event.context!, FilterScreen.filterScreenRoute,
          arguments: {
            "position": event.position,
            "filterAddtionalInformation": event.filterAddtionalInformation,
            "homestayType": event.homestayType
          });
    }
  }
}
