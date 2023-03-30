import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/select_next_event.dart';
import 'package:staywithme_passenger_application/bloc/state/select_next_state.dart';
import 'package:staywithme_passenger_application/model/search_filter_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/homestay_detail_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/process_booking_screen.dart';

class SelectNextHomestayBloc {
  final eventController = StreamController<SelectNextHomestayEvent>();
  final stateController = StreamController<SelectNextHomestayState>();

  int? _bookingId;
  String? _homestayType;
  FilterOptionModel? _filterOption;

  SelectNextHomestayState initData(BuildContext context) {
    final contextArgurments = ModalRoute.of(context)!.settings.arguments as Map;
    _homestayType = contextArgurments["homestayType"];
    _bookingId = contextArgurments["bookingId"];
    _filterOption = contextArgurments["filterOption"];
    return SelectNextHomestayState(
        filterOption: contextArgurments["filterOption"],
        homestayType: contextArgurments["homestayType"],
        bookingId: contextArgurments["bookingId"]);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  SelectNextHomestayBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(SelectNextHomestayEvent event) {
    if (event is OnTabChooseFilterNextHomestayEvent) {
      Navigator.pushNamed(event.context!, FilterScreen.filterScreenRoute,
          arguments: {"homestayType": event.homestayType});
    } else if (event is ViewNextHomestayDetailEvent) {
      Navigator.pushNamed(
          event.context!, HomestayDetailScreen.homestayDetailScreenRoute,
          arguments: {
            "homestayName": event.homestayName,
            "isHomestayInBloc": false
          });
    } else if (event is SubmitBookingHomestayEvent) {
      Navigator.pushReplacementNamed(
          event.context!, ProcessBookingScreen.processBookingScreenRoute,
          arguments: {"bookingId": event.bookingId});
    }
    stateController.sink.add(SelectNextHomestayState(
        bookingId: _bookingId,
        filterOption: _filterOption,
        homestayType: _homestayType));
  }
}
