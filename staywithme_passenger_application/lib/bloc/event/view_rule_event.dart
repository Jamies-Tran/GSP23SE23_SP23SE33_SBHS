import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

abstract class ViewHomestayRuleEvent {}

class OnNextStepToOverviewEvent extends ViewHomestayRuleEvent {
  OnNextStepToOverviewEvent(
      {this.context,
      this.homestay,
      this.bookingId,
      this.bookingStart,
      this.bookingEnd,
      this.homestayServiceList,
      this.totalServicePrice});

  BuildContext? context;
  HomestayModel? homestay;
  int? bookingId;
  String? bookingStart;
  String? bookingEnd;
  List<HomestayServiceModel>? homestayServiceList;
  int? totalServicePrice;
}
