import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

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
      {this.context, this.homestay, this.bookingStart, this.bookingEnd});

  BuildContext? context;
  HomestayModel? homestay;
  String? bookingStart;
  String? bookingEnd;
}
