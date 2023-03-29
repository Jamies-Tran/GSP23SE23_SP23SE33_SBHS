import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

abstract class ViewBlocHomestayRuleEvent {}

class OnNextStepToChooseHomestayInBlocEvent extends ViewBlocHomestayRuleEvent {
  OnNextStepToChooseHomestayInBlocEvent(
      {this.context,
      this.bookingStart,
      this.bookingEnd,
      this.blocBookingValidation,
      this.bookingBlocList,
      this.blocServiceList,
      this.bloc,
      this.bookingId,
      this.totalHomestayPrice,
      this.totalServicePrice});
  BuildContext? context;
  String? bookingStart;
  String? bookingEnd;
  BlocBookingDateValidationModel? blocBookingValidation;
  List<BookingBlocModel>? bookingBlocList;
  List<HomestayServiceModel>? blocServiceList;
  BlocHomestayModel? bloc;
  int? bookingId;
  int? totalHomestayPrice;
  int? totalServicePrice;
}
