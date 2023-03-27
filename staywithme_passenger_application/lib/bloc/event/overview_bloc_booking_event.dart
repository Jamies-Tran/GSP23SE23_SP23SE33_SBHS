import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/booking_bloc_screen.dart';

abstract class OverviewBookingBlocEvent {}

class ChooseBlocPaymentMethodEvent extends OverviewBookingBlocEvent {
  ChooseBlocPaymentMethodEvent({this.paymentMethod});

  BlocPaymentMethod? paymentMethod;
}

class SubmitBookingBlocHomestayEvent extends OverviewBookingBlocEvent {
  SubmitBookingBlocHomestayEvent({this.context, this.bookingBlocHomestay});

  BuildContext? context;
  BookingBlocHomestayModel? bookingBlocHomestay;
}
