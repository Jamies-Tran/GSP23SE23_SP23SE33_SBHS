import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';

abstract class ShowHomestaysEvent {}

class SelectHomestayInBlocEvent extends ShowHomestaysEvent {
  SelectHomestayInBlocEvent({this.homestay});

  HomestayInBlocModel? homestay;
}

class AddHomestayInBlocEvent extends ShowHomestaysEvent {
  AddHomestayInBlocEvent({this.context, this.homestayName});

  BuildContext? context;
  String? homestayName;
}

class DeleteBookingHomestayInBlocEvent extends ShowHomestaysEvent {
  DeleteBookingHomestayInBlocEvent({this.homestayId});

  int? homestayId;
}

class BackwardToBookingListScreenEvent extends ShowHomestaysEvent {
  BackwardToBookingListScreenEvent({this.context});

  BuildContext? context;
}
