import 'package:flutter/material.dart';

abstract class ProcessBookingEvent {}

class SuccessProcessBookingEvent extends ProcessBookingEvent {
  SuccessProcessBookingEvent({this.context});

  BuildContext? context;
}
