import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/show_homestays_event.dart';
import 'package:staywithme_passenger_application/bloc/state/show_homestays_state.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_list_screen.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class ShowHomestaysBloc {
  final eventController = StreamController<ShowHomestaysEvent>();
  final stateController = StreamController<ShowHomestaysState>();

  final _bookingService = locator.get<IBookingService>();

  BlocHomestayModel? _bloc;
  BlocBookingDateValidationModel? _blocBookingValidation;
  BookingModel? _booking;
  String? _paymentMethod;
  final List<HomestayModel> _selectedBlocHomestayList = <HomestayModel>[];

  ShowHomestaysState initData(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    _bloc = contextArguments["bloc"];
    _blocBookingValidation = contextArguments["blocBookingValidation"];
    _booking = contextArguments["booking"];
    _paymentMethod = contextArguments["paymentMethod"];
    return ShowHomestaysState(
        bloc: contextArguments["bloc"],
        blocBookingValidation: contextArguments["blocBookingValidation"],
        booking: contextArguments["booking"],
        paymentMethod: contextArguments["paymentMethod"],
        selectedBlocHomestayList: <HomestayModel>[]);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  ShowHomestaysBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  Future<void> eventHandler(ShowHomestaysEvent event) async {
    if (event is SelectHomestayInBlocEvent) {
      HomestayModel? removeHomestay;
      for (HomestayModel h in _selectedBlocHomestayList) {
        if (h.id == event.homestay!.id) {
          removeHomestay = h;
        }
      }
      if (removeHomestay != null) {
        _selectedBlocHomestayList.remove(removeHomestay);
      } else {
        _selectedBlocHomestayList.add(event.homestay!);
      }
    } else if (event is AddHomestayInBlocEvent) {
      final addHomestayInBlocBookingData =
          await _bookingService.addHomestayInBlocToBooking(
              event.homestayName!, _paymentMethod!, _booking!.id!);
      if (addHomestayInBlocBookingData is String) {
        _booking = await _bookingService.getBookingById(_booking!.id!);
        BookingValidateModel bookingValidateModel = BookingValidateModel(
            bookingStart: _booking!.bookingFrom,
            bookingEnd: _booking!.bookingTo,
            homestayName: _booking!.bloc!.name,
            totalReservation: 5);
        _blocBookingValidation = await _bookingService
            .getBlocAvailableHomestayList(bookingValidateModel);
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
            title: const Center(
              child: Text("Notice"),
            ),
            content: SizedBox(
              height: 100,
              width: 100,
              child: Center(child: Text(addHomestayInBlocBookingData)),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context,
                        ShowBlocHomestayListScreen
                            .showBlocHomestayListScreenRoute,
                        arguments: {
                          "bloc": _bloc,
                          "blocBookingValidation": _blocBookingValidation,
                          "booking": _booking,
                          "paymentMethod": _paymentMethod
                        });
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        );
      } else if (addHomestayInBlocBookingData is ServerExceptionModel) {
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
            title: const Center(
              child: Text("Notice"),
            ),
            content: SizedBox(
              height: 100,
              width: 100,
              child: Center(child: Text(addHomestayInBlocBookingData.message!)),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        );
      } else if (addHomestayInBlocBookingData is TimeoutException ||
          addHomestayInBlocBookingData is SocketException) {
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
            title: const Center(
              child: Text("Notice"),
            ),
            content: const SizedBox(
              height: 100,
              width: 100,
              child: Center(child: Text("Can't connect to server")),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        );
      }
    } else if (event is DeleteBookingHomestayInBlocEvent) {
      await _bookingService.deleteBookingHomestay(
          _booking!.id!, event.homestayId!);
      _booking = await _bookingService.getBookingById(_booking!.id!);
      BookingValidateModel bookingValidateModel = BookingValidateModel(
          bookingStart: _booking!.bookingFrom,
          bookingEnd: _booking!.bookingTo,
          homestayName: _booking!.bloc!.name,
          totalReservation: 5);
      _blocBookingValidation = await _bookingService
          .getBlocAvailableHomestayList(bookingValidateModel);
      // BookingValidateModel bookingValidateModel2 = BookingValidateModel(
      //     bookingStart: _booking!.bookingFrom,
      //     bookingEnd: _booking!.bookingTo,
      //     homestayName: _bloc!.name,
      //     totalReservation: 5);
      _blocBookingValidation = await _bookingService
          .getBlocAvailableHomestayList(bookingValidateModel);
    } else if (event is BackwardToBookingListScreenEvent) {
      Navigator.pushReplacementNamed(
          event.context!, BookingLoadingScreen.bookingLoadingScreen,
          arguments: {
            "bookingId": _booking!.id!,
            "homestayType": _booking!.homestayType!.toLowerCase(),
            "blocBookingValidation": _blocBookingValidation
          });
    }

    stateController.sink.add(ShowHomestaysState(
        bloc: _bloc,
        blocBookingValidation: _blocBookingValidation,
        booking: _booking,
        selectedBlocHomestayList: _selectedBlocHomestayList));
  }
}
