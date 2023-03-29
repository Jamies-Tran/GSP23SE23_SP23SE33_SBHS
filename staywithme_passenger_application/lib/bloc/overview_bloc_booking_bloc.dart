import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/overview_bloc_booking_event.dart';
import 'package:staywithme_passenger_application/bloc/state/overview_bloc_booking_state.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/booking_bloc_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/process_bloc_booking_screen.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class OverviewBookingBlocHomestayBloc {
  final eventController = StreamController<OverviewBookingBlocEvent>();
  final stateController = StreamController<OverviewBookingBlocState>();

  final _bookingService = locator.get<IBookingService>();

  String? _bookingStart;
  String? _bookingEnd;
  BlocHomestayModel? _bloc;
  List<BookingBlocModel>? _bookingBlocList;
  List<HomestayServiceModel>? _blocServiceList;
  int? _bookingId;
  int? _totalHomestayPrice;
  int? _totalServicePrice;
  BlocPaymentMethod? _paymentMethod = BlocPaymentMethod.swm_wallet;

  OverviewBookingBlocState initData(
      String bookingStart,
      String bookingEnd,
      BlocHomestayModel bloc,
      List<BookingBlocModel> bookingBlocList,
      List<HomestayServiceModel> blocServiceList,
      int bookingId,
      int totalHomestayPrice,
      int totalServicePrice) {
    _bookingStart = bookingStart;
    _bookingEnd = bookingEnd;
    _bloc = bloc;
    _bookingBlocList = bookingBlocList;
    _blocServiceList = blocServiceList;
    _bookingId = bookingId;
    _totalHomestayPrice = totalHomestayPrice;
    _totalServicePrice = totalServicePrice;
    return OverviewBookingBlocState(
        bloc: bloc,
        blocServiceList: blocServiceList,
        bookingBlocList: bookingBlocList,
        bookingEnd: bookingEnd,
        bookingId: bookingId,
        bookingStart: bookingStart,
        paymentMethod: BlocPaymentMethod.swm_wallet,
        totalHomestayPrice: totalHomestayPrice,
        totalServicePrice: totalServicePrice);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  OverviewBookingBlocHomestayBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  Future<void> eventHandler(OverviewBookingBlocEvent event) async {
    if (event is ChooseBlocPaymentMethodEvent) {
      _paymentMethod = event.paymentMethod;
    } else if (event is SubmitBookingBlocHomestayEvent) {
      final savedBookingBlocData =
          await _bookingService.saveBlocForBooking(event.bookingBlocHomestay!);
      if (savedBookingBlocData is List<BookingHomestayModel>) {
        Navigator.pushReplacementNamed(event.context!,
            ProcessBlocBookingScreen.processBlocBookingScreenRoute,
            arguments: {"bookingId": event.bookingId});
      } else if (savedBookingBlocData is ServerExceptionModel) {
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
              title: const Center(
                child: Text("Notice"),
              ),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: 200,
                  height: 150,
                  margin: const EdgeInsets.all(20),
                  child: Text(savedBookingBlocData.message!),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"))
              ]),
        );
      } else if (savedBookingBlocData is SocketException ||
          savedBookingBlocData is TimeoutException) {
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
              title: const Center(
                child: Text("Notice"),
              ),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: 200,
                  height: 150,
                  margin: const EdgeInsets.all(20),
                  child: const Text("Can't connect to server"),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"))
              ]),
        );
      }
    } else if (event is EditHomestayInBlocEvent) {
      Navigator.pushNamed(
          event.context!, BookingBlocScreen.bookingBlocScreenRoute,
          arguments: {
            "selectedIndex": 2,
            "overviewFlag": event.overviewFlag,
            "bloc": event.bloc,
            "bookingStart": event.bookingStart,
            "bookingEnd": event.bookingEnd,
            "blocBookingValidation": event.blocBookingValidation,
            "bookingBlocList": event.bookingBlocList,
            "blocServiceList": event.blocServiceList,
            "bookingId": event.bookingId,
            "totalHomestayPrice": event.totalHomestayPrice,
            "totalServicePrice": event.totalServicePrice
          });
    } else if (event is EditBlocServiceListEvent) {
      Navigator.pushNamed(
          event.context!, BookingBlocScreen.bookingBlocScreenRoute,
          arguments: {
            "selectedIndex": 3,
            "overviewFlag": event.overviewFlag,
            "bloc": event.bloc,
            "bookingStart": event.bookingStart,
            "bookingEnd": event.bookingEnd,
            "blocBookingValidation": event.blocBookingValidation,
            "bookingBlocList": event.bookingBlocList,
            "blocServiceList": event.blocServiceList,
            "bookingId": event.bookingId,
            "totalHomestayPrice": event.totalHomestayPrice,
            "totalServicePrice": event.totalServicePrice,
          });
    }
    stateController.sink.add(OverviewBookingBlocState(
        bloc: _bloc,
        blocServiceList: _blocServiceList,
        bookingBlocList: _bookingBlocList,
        bookingStart: _bookingStart,
        bookingEnd: _bookingEnd,
        bookingId: _bookingId,
        paymentMethod: _paymentMethod,
        totalHomestayPrice: _totalHomestayPrice,
        totalServicePrice: _totalServicePrice));
  }
}
