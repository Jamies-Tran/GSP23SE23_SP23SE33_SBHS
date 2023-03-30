import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

abstract class ViewHomestayRuleEvent {}

class OnNextStepToChooseHomestayServiceEvent extends ViewHomestayRuleEvent {
  OnNextStepToChooseHomestayServiceEvent({
    this.context,
    this.homestay,
    this.bookingId,
    this.bookingStart,
    this.bookingEnd,
  });

  BuildContext? context;
  HomestayModel? homestay;
  int? bookingId;
  String? bookingStart;
  String? bookingEnd;
}
