import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

abstract class ViewHomestayInBlocFacilityEvent {}

class SelectHomestayInBlocEvent extends ViewHomestayInBlocFacilityEvent {
  SelectHomestayInBlocEvent(
      {this.currentIndex, this.totalHomestays, this.isNext});

  int? currentIndex;
  int? totalHomestays;
  bool? isNext;
}

class OnNextStepToBlocRuleEvent extends ViewHomestayInBlocFacilityEvent {
  OnNextStepToBlocRuleEvent(
      {this.context,
      this.bookingStart,
      this.bookingEnd,
      this.bookingBlocList,
      this.blocServiceList,
      this.bloc,
      this.bookingId,
      this.totalHomestayPrice,
      this.totalServicePrice});

  BuildContext? context;
  String? bookingStart;
  String? bookingEnd;
  List<BookingBlocModel>? bookingBlocList;
  List<HomestayServiceModel>? blocServiceList;
  BlocHomestayModel? bloc;
  int? bookingId;
  int? totalHomestayPrice;
  int? totalServicePrice;
}
