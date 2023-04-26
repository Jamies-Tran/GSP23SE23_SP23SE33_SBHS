import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';

class ChooseDateForBlocHomestayState {
  ChooseDateForBlocHomestayState(
      {this.bloc,
      this.blocBookingValidation,
      this.msg,
      this.msgFontColor,
      this.isBookingValid});

  BlocHomestayModel? bloc;
  BlocBookingDateValidationModel? blocBookingValidation;
  String? msg;
  Color? msgFontColor;
  bool? isBookingValid;
}
