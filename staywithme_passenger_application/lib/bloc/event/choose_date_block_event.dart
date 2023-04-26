import 'package:flutter/material.dart';

abstract class ChooseDateForBlocHomestayEvent {}

class GetAvailableHomestayListInBlocEvent
    extends ChooseDateForBlocHomestayEvent {
  GetAvailableHomestayListInBlocEvent({this.bookingStart, this.bookingEnd});

  String? bookingStart;
  String? bookingEnd;
}

class CreateBookingForBlocEvent extends ChooseDateForBlocHomestayEvent {
  CreateBookingForBlocEvent({this.context, this.bookingStart, this.bookingEnd});

  BuildContext? context;
  String? bookingStart;
  String? bookingEnd;
}
