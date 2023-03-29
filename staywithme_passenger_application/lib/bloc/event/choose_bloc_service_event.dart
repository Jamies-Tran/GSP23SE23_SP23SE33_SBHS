import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

abstract class ChooseBlocServiceEvent {}

class OnChooseServiceEvent extends ChooseBlocServiceEvent {
  OnChooseServiceEvent({this.homestayServiceModel});

  HomestayServiceModel? homestayServiceModel;
}

class OnNextStepToOviewBlocBookingEvent extends ChooseBlocServiceEvent {
  OnNextStepToOviewBlocBookingEvent(
      {this.context,
      this.bookingStart,
      this.bookingEnd,
      this.blocBookingValidation,
      this.bookingBlocList,
      this.blocServiceList,
      this.bookingId,
      this.bloc,
      this.totalHomestayPrice,
      this.totalServicePrice,
      this.overviewFlag});

  BuildContext? context;
  String? bookingStart;
  String? bookingEnd;
  BlocBookingDateValidationModel? blocBookingValidation;
  List<BookingBlocModel>? bookingBlocList;
  List<HomestayServiceModel>? blocServiceList;
  int? bookingId;
  BlocHomestayModel? bloc;
  int? totalHomestayPrice;
  int? totalServicePrice;
  bool? overviewFlag;
}
