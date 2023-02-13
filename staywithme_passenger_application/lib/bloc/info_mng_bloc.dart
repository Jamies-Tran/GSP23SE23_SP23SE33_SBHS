import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/info_mng_event.dart';
import 'package:staywithme_passenger_application/screen/personal/add_balance_screen.dart';
import 'package:staywithme_passenger_application/screen/personal/payment_history_screen.dart';

class InfoManagementBloc {
  final eventController = StreamController<InfoManagementEvent>();
  final stateController = StreamController();

  void dispose() {
    eventController.close();
    stateController.close();
  }

  InfoManagementBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(InfoManagementEvent event) {
    if (event is NavigateToAddBalanceScreenEvent) {
      Navigator.pushNamed(
          event.context!, AddBalanceScreen.addBalanceScreenRoute,
          arguments: {"username": event.username});
    } else if (event is NavigateToPaymentHistoryScreenEvent) {
      Navigator.pushNamed(
          event.context!, PaymentHistoryScreen.paymentHistoryScreenRoute,
          arguments: {"username": event.username});
    }
  }
}
