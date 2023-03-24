import 'package:flutter/widgets.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';

abstract class BlocHomestayDetailEvent {}

class OnGetBlocAvailableHomestayListEvent extends BlocHomestayDetailEvent {
  OnGetBlocAvailableHomestayListEvent(
      {this.bookingStart, this.bookingEnd, this.blocName, this.msg});

  String? bookingStart;
  String? bookingEnd;
  String? blocName;
  String? msg;
}

class CreateBookingEvent extends BlocHomestayDetailEvent {
  CreateBookingEvent(
      {this.context,
      this.bloc,
      this.blocBookingDateValidation,
      this.bookingStart,
      this.bookingEnd});

  BuildContext? context;
  BlocHomestayModel? bloc;
  BlocBookingDateValidationModel? blocBookingDateValidation;
  String? bookingStart;
  String? bookingEnd;
}
