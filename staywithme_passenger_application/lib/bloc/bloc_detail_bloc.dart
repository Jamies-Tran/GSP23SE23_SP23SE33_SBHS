import 'dart:async';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/bloc_detail_event.dart';
import 'package:staywithme_passenger_application/bloc/state/bloc_detail_state.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_bloc_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_screen.dart';
import 'package:staywithme_passenger_application/screen/main_screen.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class BlocHomestayDetailBloc {
  final eventController = StreamController<BlocHomestayDetailEvent>();
  final stateController = StreamController<BlocHomestayDetailState>();

  final _bookingService = locator.get<IBookingService>();
  final _firebaseAuth = FirebaseAuth.instance;

  BlocBookingDateValidationModel? _blocBookingDateValidation;
  String? _msg;
  Color? _msgFontColor;
  bool? _isBookingValid;
  String? _name;

  BlocHomestayDetailState initData(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    _name = contextArguments["blocName"];
    return BlocHomestayDetailState(
        name: contextArguments["blocName"],
        msg: null,
        msgFontColor: null,
        isBookingValid: false,
        blocBookingDateValidation: null);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  BlocHomestayDetailBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  Future<void> eventHandler(BlocHomestayDetailEvent event) async {
    if (event is OnGetBlocAvailableHomestayListEvent) {
      final bookingValidationModel = BookingValidateModel(
          bookingStart: event.bookingStart,
          bookingEnd: event.bookingEnd,
          homestayName: event.blocName);
      final blocBookingDateValidationData = await _bookingService
          .getBlocAvailableHomestayList(bookingValidationModel);
      if (blocBookingDateValidationData is BlocBookingDateValidationModel) {
        if (blocBookingDateValidationData.homestays!.isNotEmpty) {
          _blocBookingDateValidation = blocBookingDateValidationData;
          _msg =
              "${blocBookingDateValidationData.homestays!.length} available homestay from ${event.bookingStart} to ${event.bookingEnd}";
          _msgFontColor = Colors.green;
          _isBookingValid = true;
        } else {
          _msg = "No available homestay";
          _msgFontColor = Colors.red;
          _isBookingValid = false;
        }
      }
    } else if (event is CreateBookingEvent) {
      if (_firebaseAuth.currentUser == null) {
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
            title: const Center(child: Text("Notice")),
            content: const SizedBox(
                height: 200,
                width: 200,
                child: Text("You must login before taking a booking")),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No, want to look around first")),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MainScreen.mainScreenRoute,
                        arguments: {"startingIndex": 1});
                  },
                  child: const Text("Let's log in"))
            ],
          ),
        );
      } else {
        final bookingData = await _bookingService.createBooking(
            HomestayType.bloc.name, event.bookingStart!, event.bookingEnd!);
        if (bookingData is BookingModel) {
          Navigator.pushNamed(
              event.context!, BookingBlocScreen.bookingBlocScreenRoute,
              arguments: {
                "bloc": event.bloc,
                "blocBookingValidation": event.blocBookingDateValidation,
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
                  height: 200,
                  width: 200,
                  child: Text("${bookingData.message}")),
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
    }
    stateController.sink.add(BlocHomestayDetailState(
        name: _name,
        msg: _msg,
        msgFontColor: _msgFontColor,
        isBookingValid: _isBookingValid,
        blocBookingDateValidation: _blocBookingDateValidation));
  }
}
