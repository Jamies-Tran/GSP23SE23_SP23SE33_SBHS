import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

abstract class ChooseServiceEvent {}

class OnTabHomestayServiceEvent extends ChooseServiceEvent {
  OnTabHomestayServiceEvent({this.homestayServiceModel});

  HomestayServiceModel? homestayServiceModel;
}

class OnNextStepToOverviewBookingHomestayEvent extends ChooseServiceEvent {
  OnNextStepToOverviewBookingHomestayEvent(
      {this.context,
      this.homestay,
      this.bookingId,
      this.homestayServiceList,
      this.totalServicePrice,
      this.bookingEnd,
      this.bookingStart});

  BuildContext? context;
  HomestayModel? homestay;
  int? bookingId;
  List<HomestayServiceModel>? homestayServiceList;
  int? totalServicePrice;
  String? bookingStart;
  String? bookingEnd;
}
