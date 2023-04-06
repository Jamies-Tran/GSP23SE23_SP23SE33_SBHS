import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

abstract class OverviewBookingBlocEvent {}

class SubmitBookingBlocHomestayEvent extends OverviewBookingBlocEvent {
  SubmitBookingBlocHomestayEvent(
      {this.context,
      this.bookingBlocHomestay,
      this.blocBookingDateValidation,
      this.bookingId});

  BuildContext? context;
  BookingBlocHomestayModel? bookingBlocHomestay;
  BlocBookingDateValidationModel? blocBookingDateValidation;
  int? bookingId;
}

class EditBlocServiceListEvent extends OverviewBookingBlocEvent {
  EditBlocServiceListEvent(
      {this.context,
      this.blocBookingValidation,
      this.bookingStart,
      this.bookingEnd,
      this.bookingBlocList,
      this.blocServiceList,
      this.bloc,
      this.bookingId,
      this.totalHomestayPrice,
      this.totalServicePrice,
      this.overviewFlag});

  BuildContext? context;
  BlocBookingDateValidationModel? blocBookingValidation;
  String? bookingStart;
  String? bookingEnd;
  List<BookingBlocModel>? bookingBlocList;
  List<HomestayServiceModel>? blocServiceList;
  BlocHomestayModel? bloc;
  int? bookingId;
  int? totalHomestayPrice;
  int? totalServicePrice;
  bool? overviewFlag;
}

class EditHomestayInBlocEvent extends OverviewBookingBlocEvent {
  EditHomestayInBlocEvent(
      {this.context,
      this.bookingStart,
      this.bookingEnd,
      this.bookingBlocList,
      this.blocServiceList,
      this.blocBookingValidation,
      this.bloc,
      this.bookingId,
      this.totalHomestayPrice,
      this.totalServicePrice,
      this.overviewFlag});
  BuildContext? context;
  String? bookingStart;
  String? bookingEnd;
  List<BookingBlocModel>? bookingBlocList;
  List<HomestayServiceModel>? blocServiceList;
  BlocBookingDateValidationModel? blocBookingValidation;
  BlocHomestayModel? bloc;
  int? bookingId;
  int? totalHomestayPrice;
  int? totalServicePrice;
  bool? overviewFlag;
}
