import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:staywithme_passenger_application/bloc/state/choose_date_homestay_state.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_homestay_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_screen.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

import 'event/choose_date_homestay_event.dart';

class ChooseDateForHomestayBloc {
  final eventController = StreamController<ChooseDateForHomestayEvent>();
  final stateController = StreamController<ChooseDateForHomestayState>();

  final _bookingService = locator.get<IBookingService>();

  HomestayModel? _homestay;

  bool? _isBookingValid;
  bool? _brownseHomestayFlag;
  String? _bookingStart;
  String? _bookingEnd;
  String? _msg;
  Color? _msgFontColor;

  ChooseDateForHomestayState initData(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    _homestay = contextArguments["homestay"];
    _brownseHomestayFlag = contextArguments["brownseHomestayFlag"];
    _bookingStart = contextArguments["bookingStart"];
    _bookingEnd = contextArguments["bookingEnd"];
    return ChooseDateForHomestayState(
        homestay: contextArguments["homestay"],
        brownseHomestayFlag: contextArguments["brownseHomestayFlag"] ?? false,
        isBookingValid: false,
        bookingStart: contextArguments["bookingStart"],
        bookingEnd: contextArguments["bookingEnd"],
        msg: null,
        msgFontColor: null);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  ChooseDateForHomestayBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  Future<void> eventHandler(ChooseDateForHomestayEvent event) async {
    if (event is CheckValidBookingDateEvent) {
      BookingValidateModel bookingValidateModel = BookingValidateModel(
          bookingStart: event.bookingStart,
          bookingEnd: event.bookingEnd,
          homestayName: _homestay!.name,
          totalReservation: 0);
      _isBookingValid = await _bookingService
          .checkValidBookingDateForHomestay(bookingValidateModel);
      if (_isBookingValid!) {
        _msg =
            "Homestay available from ${event.bookingStart} to ${event.bookingEnd}";
        _msgFontColor = Colors.green;
      } else {
        _msg = "Homestay has been booked";
        _msgFontColor = Colors.green;
      }
    } else if (event is CreateBookingEvent) {
      final bookingData = await _bookingService.createBooking(
          HomestayType.homestay.name, event.bookingStart!, event.bookingEnd!);
      if (bookingData is BookingModel) {
        Navigator.pushNamed(
            event.context!, BookingHomestayScreen.bookingHomestayScreenRoute,
            arguments: {
              "homestay": _homestay,
              "bookingId": bookingData.id,
              "bookingStart": event.bookingStart,
              "bookingEnd": event.bookingEnd
            });
      } else if (bookingData is ServerExceptionModel) {
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
            title: const Center(child: Text("Notice")),
            content: SizedBox(
                height: 200, width: 200, child: Text("${bookingData.message}")),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
            ],
          ),
        );
      } else if (bookingData is TimeoutException ||
          bookingData is SocketException) {
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
            title: const Center(child: Text("Notice")),
            content: const SizedBox(
                height: 200, width: 200, child: Text("Network error")),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
            ],
          ),
        );
      }
    }

    stateController.sink.add(ChooseDateForHomestayState(
        homestay: _homestay,
        brownseHomestayFlag: _brownseHomestayFlag,
        isBookingValid: _isBookingValid,
        msg: _msg,
        bookingStart: _bookingStart,
        bookingEnd: _bookingEnd,
        msgFontColor: _msgFontColor));
  }
}
