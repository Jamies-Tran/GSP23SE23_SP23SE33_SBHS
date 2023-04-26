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
      {this.context,
      this.homestay,
      this.bookingStart,
      this.bookingEnd,
      this.brownseHomestayFlag});

  BuildContext? context;
  HomestayModel? homestay;
  bool? brownseHomestayFlag;
  String? bookingStart;
  String? bookingEnd;
}

class ViewBlocEvent extends HomestayDetailEvent {
  ViewBlocEvent({this.context, this.blocName});

  BuildContext? context;
  String? blocName;
}
