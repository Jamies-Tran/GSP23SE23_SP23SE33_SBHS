import 'package:flutter/widgets.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

abstract class ViewHomestayFacilityEvent {}

class OnNextStepToHomestayRuleEvent extends ViewHomestayFacilityEvent {
  OnNextStepToHomestayRuleEvent({
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
