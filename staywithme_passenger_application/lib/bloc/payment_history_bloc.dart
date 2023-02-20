import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/payment_history_event.dart';
import 'package:staywithme_passenger_application/screen/personal/payment_history_screen.dart';

class PaymentHistoryBloc {
  final eventController = StreamController<PaymentHistoryEvent>();

  PaymentHistoryBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(PaymentHistoryEvent event) {
    if (event is NextPageEvent) {
      Navigator.pushNamed(
          event.context!, PaymentHistoryScreen.paymentHistoryScreenRoute,
          arguments: {
            "username": event.username,
            "isNextPage": true,
            "isPreviousPage": false,
            "page": event.pageNumber
          });
    } else if (event is PreviousPageEvent) {
      Navigator.pushNamed(
          event.context!, PaymentHistoryScreen.paymentHistoryScreenRoute,
          arguments: {
            "username": event.username,
            "isNextPage": false,
            "isPreviousPage": true,
            "page": event.pageNumber
          });
    }
  }
}
