import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';

abstract class BookingLoadingEvent {}

class GetBookingSuccessEvent extends BookingLoadingEvent {
  GetBookingSuccessEvent(
      {this.context,
      this.booking,
      this.homestayType,
      this.bookingHomestayIndex,
      this.isBookingHomestay,
      this.blocBookingValidation,
      this.viewDetail,
      this.isHost});

  BuildContext? context;
  BookingModel? booking;
  String? homestayType;
  bool? isBookingHomestay;
  int? bookingHomestayIndex;
  BlocBookingDateValidationModel? blocBookingValidation;
  bool? viewDetail;
  bool? isHost;
}
