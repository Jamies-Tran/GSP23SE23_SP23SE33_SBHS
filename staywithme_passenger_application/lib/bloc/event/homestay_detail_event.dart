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
  CreateBookingEvent({this.context, this.homestayName});

  BuildContext? context;
  String? homestayName;
}
