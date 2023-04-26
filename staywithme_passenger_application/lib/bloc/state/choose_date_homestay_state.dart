import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

class ChooseDateForHomestayState {
  ChooseDateForHomestayState(
      {this.homestay,
      this.isBookingValid,
      this.brownseHomestayFlag,
      this.msg,
      this.bookingStart,
      this.bookingEnd,
      this.msgFontColor});

  HomestayModel? homestay;
  bool? isBookingValid;
  bool? brownseHomestayFlag;
  String? msg;
  String? bookingStart;
  String? bookingEnd;
  Color? msgFontColor;
}
