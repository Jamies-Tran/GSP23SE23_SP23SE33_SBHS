import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:staywithme_passenger_application/bloc/event/booking_event.dart';
import 'package:staywithme_passenger_application/bloc/state/booking_state.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

class BookingBloc {
  final eventContoller = StreamController<BookingEvent>();
  final stateController = StreamController<BookingState>();

  BookingState initData(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    return BookingState(
        homestayName: contextArguments["homestayName"],
        bookingId: contextArguments["bookingId"],
        bookingStart: contextArguments["bookingStart"],
        bookingEnd: contextArguments["bookingEnd"],
        selectedIndex: contextArguments["selectedIndex"] ?? 0,
        homestayServiceList:
            contextArguments["homestayServiceList"] ?? <HomestayServiceModel>[],
        totalServicePrice: contextArguments["totalServicePrice"] ?? 0);
  }

  void dispose() {
    eventContoller.close();
    stateController.close();
  }
}
