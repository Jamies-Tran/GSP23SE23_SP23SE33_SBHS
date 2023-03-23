import 'package:flutter/material.dart';

abstract class HomestayDetailEvent {}

class OnCheckValidBookingDateEvent extends HomestayDetailEvent {
  OnCheckValidBookingDateEvent(
      {this.bookingStart, this.bookingEnd, this.homestayName, this.msg});

  String? bookingStart;
  String? bookingEnd;
  String? homestayName;
  String? msg;
}

class CreateBookingEvent extends HomestayDetailEvent {
  CreateBookingEvent(
      {this.context,
      this.homestayName,
      this.homestayId,
      this.bookingStart,
      this.bookingEnd});

  BuildContext? context;
  String? homestayName;
  int? homestayId;
  String? bookingStart;
  String? bookingEnd;
}
