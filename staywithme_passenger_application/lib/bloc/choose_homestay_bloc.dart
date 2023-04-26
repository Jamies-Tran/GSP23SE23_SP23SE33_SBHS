import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/choose_homestay_event.dart';
import 'package:staywithme_passenger_application/bloc/state/choose_homestay_state.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_bloc_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/homestay_detail_screen.dart';

class ChooseHomestayBloc {
  final eventController = StreamController<ChooseHomestayEvent>();
  final stateController = StreamController<ChooseHomestayState>();

  List<BookingBlocModel> _bookingBlocModelList = <BookingBlocModel>[];
  BlocHomestayModel? _bloc;

  ChooseHomestayState initData(
      List<BookingBlocModel>? bookingBlocList, BlocHomestayModel bloc) {
    _bookingBlocModelList = bookingBlocList ?? <BookingBlocModel>[];
    _bloc = bloc;
    return ChooseHomestayState(
        bookingBlocList: bookingBlocList ?? <BookingBlocModel>[], bloc: bloc);
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
      if (event.overviewFlag == true) {
        Navigator.pushNamed(
            event.context!, BookingBlocScreen.bookingBlocScreenRoute,
            arguments: {
              "selectedIndex": 4,
              "bookingStart": event.bookingStart,
              "bookingEnd": event.bookingEnd,
              "bookingBlocList": event.bookingBlocList,
              "blocBookingValidation": event.blocBookingValidation,
              "bloc": event.bloc,
              "bookingId": event.bookingId,
              "totalHomestayPrice": event.totalHomestayPrice,
              "totalServicePrice": event.totalServicePrice,
              "blocServiceList": event.blocServiceList
            });
      } else {
        Navigator.pushNamed(
            event.context!, BookingBlocScreen.bookingBlocScreenRoute,
            arguments: {
              "selectedIndex": 3,
              "blocBookingValidation": event.blocBookingValidation,
              "bookingStart": event.bookingStart,
              "bookingEnd": event.bookingEnd,
              "bookingBlocList": event.bookingBlocList,
              "bloc": event.bloc,
              "bookingId": event.bookingId,
              "totalHomestayPrice": event.totalHomestayPrice
            });
      }
    }
    stateController.sink.add(ChooseHomestayState(
        bookingBlocList: _bookingBlocModelList, bloc: _bloc));
  }
}
