import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';
import 'package:staywithme_passenger_application/screen/homestay/booking_homestay_screen.dart';

abstract class OverviewBookingEvent {}

class ChoosePaymentMethodEvent extends OverviewBookingEvent {
  ChoosePaymentMethodEvent({this.paymentMethod});

  PaymentMethod? paymentMethod;
}

class SaveBookingHomestayEvent extends OverviewBookingEvent {
  SaveBookingHomestayEvent(
      {this.context, this.bookingHomestay, this.bookingId});

  BuildContext? context;
  BookingHomestayModel? bookingHomestay;
  int? bookingId;
}

class EditHomestayServiceBookingEvent extends OverviewBookingEvent {
  EditHomestayServiceBookingEvent(
      {this.conext,
      this.homestayServiceList,
      this.homestayName,
      this.bookingStart,
      this.bookingEnd,
      this.totalServicePrice});

  BuildContext? conext;
  List<HomestayServiceModel>? homestayServiceList;
  String? homestayName;
  String? bookingStart;
  String? bookingEnd;
  int? totalServicePrice;
}
