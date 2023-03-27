import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';

abstract class ChooseHomestayEvent {}

class OnChooseHomestayEvent extends ChooseHomestayEvent {
  OnChooseHomestayEvent({this.bookingBloc});

  BookingBlocModel? bookingBloc;
}

class OnShowHomestayDetailEvent extends ChooseHomestayEvent {
  OnShowHomestayDetailEvent({this.context, this.homestayName});

  BuildContext? context;
  String? homestayName;
}

class OnNextStepToChooseServiceEvent extends ChooseHomestayEvent {
  OnNextStepToChooseServiceEvent(
      {this.context,
      this.bookingBlocList,
      this.bloc,
      this.bookingId,
      this.totalHomestayPrice});

  BuildContext? context;
  List<BookingBlocModel>? bookingBlocList;

  BlocHomestayModel? bloc;
  int? bookingId;

  int? totalHomestayPrice;
}
