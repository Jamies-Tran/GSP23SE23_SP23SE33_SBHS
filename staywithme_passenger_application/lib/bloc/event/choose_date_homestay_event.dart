import 'package:flutter/material.dart';

abstract class ChooseDateForHomestayEvent {}

class CheckValidBookingDateEvent extends ChooseDateForHomestayEvent {
  CheckValidBookingDateEvent({this.bookingStart, this.bookingEnd});

  String? bookingStart;
  String? bookingEnd;
}

class CreateBookingEvent extends ChooseDateForHomestayEvent {
  CreateBookingEvent({this.context, this.bookingStart, this.bookingEnd});

  BuildContext? context;
  String? bookingStart;
  String? bookingEnd;
}
