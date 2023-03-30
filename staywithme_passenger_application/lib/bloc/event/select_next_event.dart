import 'package:flutter/material.dart';

abstract class SelectNextHomestayEvent {}

class OnTabChooseFilterNextHomestayEvent extends SelectNextHomestayEvent {
  OnTabChooseFilterNextHomestayEvent({this.context, this.homestayType});

  BuildContext? context;
  String? homestayType;
}

class ViewNextHomestayDetailEvent extends SelectNextHomestayEvent {
  ViewNextHomestayDetailEvent({this.context, this.homestayName});

  BuildContext? context;
  String? homestayName;
}

class SubmitBookingHomestayEvent extends SelectNextHomestayEvent {
  SubmitBookingHomestayEvent({this.context, this.bookingId});

  BuildContext? context;
  int? bookingId;
}
