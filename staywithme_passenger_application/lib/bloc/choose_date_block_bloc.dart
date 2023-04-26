import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/choose_date_block_event.dart';
import 'package:staywithme_passenger_application/bloc/state/choose_date_block_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_bloc_screen.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_list_screen.dart';
import 'package:staywithme_passenger_application/screen/homestay/filter_screen.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class ChooseDateForBlocHomestayBloc {
  final eventController = StreamController<ChooseDateForBlocHomestayEvent>();
  final stateController = StreamController<ChooseDateForBlocHomestayState>();

  final _bookingService = locator.get<IBookingService>();
  BlocHomestayModel? _bloc;
  BlocBookingDateValidationModel? _blocBookingDateValidation;
  String? _msg;
  Color? _msgFontColor;
  bool? _isBookingValid;

  ChooseDateForBlocHomestayState initData(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    _bloc = contextArguments["bloc"];

    return ChooseDateForBlocHomestayState(
        bloc: contextArguments["bloc"],
        blocBookingValidation: null,
        isBookingValid: false,
        msg: null,
        msgFontColor: null);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  ChooseDateForBlocHomestayBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  Future<void> eventHandler(ChooseDateForBlocHomestayEvent event) async {
    if (event is GetAvailableHomestayListInBlocEvent) {
      final bookingValidationModel = BookingValidateModel(
          bookingStart: event.bookingStart,
          bookingEnd: event.bookingEnd,
          homestayName: _bloc!.name);
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
    } else if (event is CreateBookingForBlocEvent) {
      final bookingData =
          await _bookingService.getBookingSavedBlocHomestayType();
      if (bookingData is BookingModel) {
        final bookingValidationModel = BookingValidateModel(
            bookingStart: event.bookingStart,
            bookingEnd: event.bookingEnd,
            homestayName: _bloc!.name);
        BlocBookingDateValidationModel blocBookingValidation =
            await _bookingService
                .getBlocAvailableHomestayList(bookingValidationModel);
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
            title: const Center(child: Text("Notice")),
            content: SizedBox(
              width: 50,
              height: 100,
              child: Column(children: const [
                Text(
                    "You already have a booking for block homestay that haven't been submitted"),
                Text("Do you want to continue with that booking or create new?")
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, BookingLoadingScreen.bookingLoadingScreen,
                        arguments: {
                          "bookingId": bookingData.id,
                          "homestayType": bookingData.homestayType,
                          "blocBookingValidation": blocBookingValidation
                        });
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: secondaryColor),
                  )),
              TextButton(
                  onPressed: () async {
                    await _bookingService.deleteBooking(bookingData.id!);
                    final createBookingData =
                        await _bookingService.createBooking(
                            HomestayType.bloc.name,
                            event.bookingStart!,
                            event.bookingEnd!);
                    if (createBookingData is BookingModel) {
                      Navigator.pushNamed(event.context!,
                          BookingBlocScreen.bookingBlocScreenRoute,
                          arguments: {
                            "bloc": _bloc,
                            "blocBookingValidation": blocBookingValidation,
                            "bookingId": createBookingData.id,
                            "bookingStart": event.bookingStart,
                            "bookingEnd": event.bookingEnd
                          });
                    } else if (createBookingData is ServerExceptionModel) {
                      showDialog(
                        context: event.context!,
                        builder: (context) => AlertDialog(
                          title: const Center(child: Text("Notice")),
                          content: SizedBox(
                              height: 200,
                              width: 200,
                              child: Text("${createBookingData.message}")),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                          ],
                        ),
                      );
                    } else if (createBookingData is TimeoutException ||
                        createBookingData is SocketException) {
                      showDialog(
                        context: event.context!,
                        builder: (context) => AlertDialog(
                          title: const Center(child: Text("Notice")),
                          content: const SizedBox(
                              height: 200,
                              width: 200,
                              child: Text("Network error")),
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
                  },
                  child: const Text(
                    "Create new",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: primaryColor),
                  ))
            ],
          ),
        );
      } else if (bookingData is ServerExceptionModel) {
        if (bookingData.statusCode == 404) {
          final createBookingData = await _bookingService.createBooking(
              HomestayType.bloc.name, event.bookingStart!, event.bookingEnd!);
          if (createBookingData is BookingModel) {
            Navigator.pushNamed(
                event.context!, BookingBlocScreen.bookingBlocScreenRoute,
                arguments: {
                  "bloc": _bloc,
                  "blocBookingValidation": _blocBookingDateValidation,
                  "bookingId": createBookingData.id,
                  "bookingStart": event.bookingStart,
                  "bookingEnd": event.bookingEnd
                });
          } else if (createBookingData is ServerExceptionModel) {
            showDialog(
              context: event.context!,
              builder: (context) => AlertDialog(
                title: const Center(child: Text("Notice")),
                content: SizedBox(
                    height: 200,
                    width: 200,
                    child: Text("${createBookingData.message}")),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                ],
              ),
            );
          } else if (createBookingData is TimeoutException ||
              createBookingData is SocketException) {
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
    }
    stateController.sink.add(ChooseDateForBlocHomestayState(
        bloc: _bloc,
        blocBookingValidation: _blocBookingDateValidation,
        isBookingValid: _isBookingValid,
        msg: _msg,
        msgFontColor: _msgFontColor));
  }
}
