import 'package:flutter/material.dart';

abstract class BookingHistoryEvent {}

class ChooseHomestayTypeEvent extends BookingHistoryEvent {
  ChooseHomestayTypeEvent({this.homestayType});

  String? homestayType;
}

class ChooseHomestayStatusEvent extends BookingHistoryEvent {
  ChooseHomestayStatusEvent({this.status});

  String? status;
}

class ChooseHostOrGuestHomestayEvent extends BookingHistoryEvent {
  ChooseHostOrGuestHomestayEvent({this.isHost});

  bool? isHost;
}

class ViewBookingDetailEvent extends BookingHistoryEvent {
  ViewBookingDetailEvent({this.context, this.bookingId, this.homestayType});

  BuildContext? context;
  int? bookingId;
  String? homestayType;
}
