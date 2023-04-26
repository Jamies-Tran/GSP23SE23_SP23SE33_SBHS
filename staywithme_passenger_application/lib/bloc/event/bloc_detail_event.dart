import 'package:flutter/widgets.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';

abstract class BlocHomestayDetailEvent {}

class ChooseBookingDateForBlocEvent extends BlocHomestayDetailEvent {
  ChooseBookingDateForBlocEvent({this.context, this.bloc});

  BuildContext? context;
  BlocHomestayModel? bloc;
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

class ViewHomestayEvent extends BlocHomestayDetailEvent {
  ViewHomestayEvent({this.context, this.homestayName});

  BuildContext? context;
  String? homestayName;
}
