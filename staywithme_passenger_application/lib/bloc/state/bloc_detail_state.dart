import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';

class BlocHomestayDetailState {
  BlocHomestayDetailState(
      {this.name,
      this.msg,
      this.msgFontColor,
      this.isBookingValid,
      this.blocBookingDateValidation});

  String? name;
  String? msg;
  Color? msgFontColor;
  bool? isBookingValid;
  BlocBookingDateValidationModel? blocBookingDateValidation;
}
