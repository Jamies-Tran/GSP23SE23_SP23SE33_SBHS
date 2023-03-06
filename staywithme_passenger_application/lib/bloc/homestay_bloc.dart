import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/homestay_event.dart';
import 'package:staywithme_passenger_application/screen/homestay/search_homestay_screen.dart';

class HomestayBloc {
  final eventController = StreamController<HomestayEvent>();

  HomestayBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(HomestayEvent event) {
    if (event is OnClickSearchTextFieldEvent) {
      Navigator.pushNamed(
          event.context!, SearchHomestayScreen.searchHomestayScreenRoute,
          arguments: {"position": event.position, "homestayType": "homestay"});
    }
  }
}
