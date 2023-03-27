import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/choose_homestay_event.dart';
import 'package:staywithme_passenger_application/bloc/state/choose_homestay_state.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/booking_bloc_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/homestay_detail_screen.dart';

class ChooseHomestayBloc {
  final eventController = StreamController<ChooseHomestayEvent>();
  final stateController = StreamController<ChooseHomestayState>();

  final List<BookingBlocModel> _bookingBlocModelList = <BookingBlocModel>[];

  ChooseHomestayState initData() {
    return ChooseHomestayState(bookingBlocList: <BookingBlocModel>[]);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  ChooseHomestayBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(ChooseHomestayEvent event) {
    if (event is OnChooseHomestayEvent) {
      BookingBlocModel? removeBookingBloc;
      for (BookingBlocModel bookingBlocModel in _bookingBlocModelList) {
        if (bookingBlocModel.homestayName == event.bookingBloc!.homestayName) {
          removeBookingBloc = bookingBlocModel;
        }
      }
      if (removeBookingBloc != null) {
        _bookingBlocModelList.remove(removeBookingBloc);
      } else {
        _bookingBlocModelList.add(event.bookingBloc!);
      }
    } else if (event is OnShowHomestayDetailEvent) {
      Navigator.pushNamed(
          event.context!, HomestayDetailScreen.homestayDetailScreenRoute,
          arguments: {
            "homestayName": event.homestayName,
            "isHomestayInBloc": true
          });
    } else if (event is OnNextStepToChooseServiceEvent) {
      Navigator.pushNamed(
          event.context!, BookingBlocScreen.bookingBlocScreenRoute,
          arguments: {
            "selectedIndex": 1,
            "bookingBlocList": event.bookingBlocList,
            "bloc": event.bloc,
            "bookingId": event.bookingId,
            "totalHomestayPrice": event.totalHomestayPrice
          });
    }
    stateController.sink
        .add(ChooseHomestayState(bookingBlocList: _bookingBlocModelList));
  }
}
