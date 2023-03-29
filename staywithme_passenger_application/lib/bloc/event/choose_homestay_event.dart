import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

abstract class ChooseHomestayEvent {}

class OnChooseHomestayEvent extends ChooseHomestayEvent {
  OnChooseHomestayEvent({this.bookingBloc});

  BookingBlocModel? bookingBloc;
}

class OnShowHomestayDetailEvent extends ChooseHomestayEvent {
  OnShowHomestayDetailEvent({this.context, this.homestayName});

  BuildContext? context;
  String? homestayName;
}

class OnNextStepToChooseServiceEvent extends ChooseHomestayEvent {
  OnNextStepToChooseServiceEvent(
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
  bool? overviewFlag;
  int? totalHomestayPrice;
  int? totalServicePrice;
}
