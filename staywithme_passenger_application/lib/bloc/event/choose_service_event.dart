import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

abstract class ChooseServiceEvent {}

class OnTabHomestayServiceEvent extends ChooseServiceEvent {
  OnTabHomestayServiceEvent({this.homestayServiceModel});

  HomestayServiceModel? homestayServiceModel;
}

class OnNextStepToHomestayFacilityEvent extends ChooseServiceEvent {
  OnNextStepToHomestayFacilityEvent(
      {this.context,
      this.homestayName,
      this.homestayServiceList,
      this.totalServicePrice,
      this.bookingEnd,
      this.bookingStart});

  BuildContext? context;
  String? homestayName;
  List<HomestayServiceModel>? homestayServiceList;
  int? totalServicePrice;
  String? bookingStart;
  String? bookingEnd;
}
