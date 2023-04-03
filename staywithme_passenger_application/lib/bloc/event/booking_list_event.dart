import 'package:flutter/widgets.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';

abstract class BookingListEvent {}

class UpdateBookingDateEvent extends BookingListEvent {
  UpdateBookingDateEvent(
      {this.context,
      this.bookingStart,
      this.bookingEnd,
      this.booking,
      this.bookingId});

  BuildContext? context;
  String? bookingStart;
  String? bookingEnd;
  BookingModel? booking;
  int? bookingId;
}

class ChooseBookingHomestayEvent extends BookingListEvent {
  ChooseBookingHomestayEvent({this.bookingHomestay});

  BookingHomestayModel? bookingHomestay;
}

class ChooseViewHomestayListEvent extends BookingListEvent {
  ChooseViewHomestayListEvent();
}

class ChooseViewServiceListEvent extends BookingListEvent {
  ChooseViewServiceListEvent();
}

class ChooseNewHomestayServiceEvent extends BookingListEvent {
  ChooseNewHomestayServiceEvent({this.serviceName});

  String? serviceName;
}

class UpdateHomestayServiceEvent extends BookingListEvent {
  UpdateHomestayServiceEvent(
      {this.context,
      this.serviceNameList,
      this.bookingId,
      this.homestayName,
      this.homestayType});

  BuildContext? context;
  List<String>? serviceNameList;
  int? bookingId;
  String? homestayName;
  String? homestayType;
}

class CancelUpdateServiceEvent extends BookingListEvent {}
