import 'package:flutter/widgets.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

abstract class ViewHomestayFacilityEvent {}

class OnNextStepToHomestayRuleEvent extends ViewHomestayFacilityEvent {
  OnNextStepToHomestayRuleEvent(
      {this.context,
      this.homestayName,
      this.bookingStart,
      this.bookingEnd,
      this.homestayServiceList,
      this.totalServicePrice});

  BuildContext? context;
  String? homestayName;
  String? bookingStart;
  String? bookingEnd;
  List<HomestayServiceModel>? homestayServiceList;
  int? totalServicePrice;
}
