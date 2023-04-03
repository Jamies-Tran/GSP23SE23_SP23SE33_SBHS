import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/booking_list_event.dart';
import 'package:staywithme_passenger_application/bloc/state/booking_list_state.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/screen/booking/booking_list_screen.dart';
import 'package:staywithme_passenger_application/service/user/booking_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class BookingListBloc {
  final eventController = StreamController<BookingListEvent>();
  final stateController = StreamController<BookingListState>();

  final bookingService = locator.get<IBookingService>();
  final _bookingHomestayChosenList = <BookingHomestayModel>[];
  BookingModel? _booking;
  String? _homestayType;
  bool? _isBookingHomestay = true;
  bool? _activeUpdateService = false;
  int? _bookingHomestayIndex = 0;
  final List<String> _serviceNameList = <String>[];

  BookingListState initData(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    _booking = contextArguments["booking"];
    _homestayType = contextArguments["homestayType"];
    for (BookingServiceModel s in _booking!.bookingHomestayServices!) {
      _serviceNameList.add(s.homestayService!.name!);
    }
    return BookingListState(
        booking: contextArguments["booking"],
        homestayType: contextArguments["homestayType"],
        bookingHomestayChosenList: <BookingHomestayModel>[],
        isBookingHomestay: true,
        bookingHomestayIndex: 0,
        serviceNameList: _serviceNameList,
        activeUpdateService: false);
  }

  void dispose() {
    stateController.close();
  }

  BookingListBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  Future<void> eventHandler(BookingListEvent event) async {
    if (event is UpdateBookingDateEvent) {
      BookingModel booking = event.booking!;
      booking.bookingFrom = event.bookingStart;
      booking.bookingTo = event.bookingEnd;
      await bookingService.updateBooking(booking, event.bookingId!);
      Navigator.pushNamed(
          event.context!, BookingLoadingScreen.bookingLoadingScreen,
          arguments: {
            "bookingId": event.bookingId,
            "homestayType": "homestay"
          });
    } else if (event is ChooseBookingHomestayEvent) {
      BookingHomestayModel? removeBookingHomestay;
      for (BookingHomestayModel b in _bookingHomestayChosenList) {
        if (b.bookingHomestayId!.bookingId ==
            event.bookingHomestay!.bookingHomestayId!.bookingId) {
          if (b.bookingHomestayId!.homestayId ==
              event.bookingHomestay!.bookingHomestayId!.homestayId) {
            removeBookingHomestay = b;
          }
        }
      }
      if (removeBookingHomestay != null) {
        _bookingHomestayChosenList.remove(removeBookingHomestay);
      } else {
        _bookingHomestayChosenList.add(event.bookingHomestay!);
      }
    } else if (event is ChooseViewHomestayListEvent) {
      _isBookingHomestay = true;
    } else if (event is ChooseViewServiceListEvent) {
      _isBookingHomestay = false;
    } else if (event is ChooseNewHomestayServiceEvent) {
      String? removeServiceName;
      for (String s in _serviceNameList) {
        if (s == event.serviceName) {
          removeServiceName = s;
        }
      }
      if (removeServiceName != null) {
        _serviceNameList.remove(removeServiceName);
      } else {
        _serviceNameList.add(event.serviceName!);
      }
      _activeUpdateService = true;
    } else if (event is UpdateHomestayServiceEvent) {
      final bookingData = await bookingService.updateBookingServices(
          event.serviceNameList!, event.bookingId!, event.homestayName!);
      if (bookingData is BookingModel) {
        Navigator.pushReplacementNamed(
            event.context!, BookingLoadingScreen.bookingLoadingScreen,
            arguments: {
              "bookingId": event.bookingId,
              "homestayType": event.homestayType
            });
      } else if (bookingData is ServerExceptionModel) {
        showDialog(
          context: event.context!,
          builder: (context) => AlertDialog(
              title: const Center(child: Text("Error")),
              content: SizedBox(
                height: 100,
                width: 50,
                child: Center(child: Text(bookingData.message!)),
              )),
        );
      } else if (bookingData is TimeoutException ||
          bookingData is SocketException) {
        showDialog(
          context: event.context!,
          builder: (context) => const AlertDialog(
              title: Center(child: Text("Error")),
              content: SizedBox(
                height: 100,
                width: 50,
                child: Center(child: Text("Can't connect to server")),
              )),
        );
      }
    }
    stateController.sink.add(BookingListState(
        bookingHomestayChosenList: _bookingHomestayChosenList,
        booking: _booking,
        homestayType: _homestayType,
        isBookingHomestay: _isBookingHomestay,
        bookingHomestayIndex: _bookingHomestayIndex,
        serviceNameList: _serviceNameList,
        activeUpdateService: _activeUpdateService));
  }
}
