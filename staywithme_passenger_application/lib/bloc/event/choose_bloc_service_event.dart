import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/bloc_model.dart';
import 'package:staywithme_passenger_application/model/booking_model.dart';
import 'package:staywithme_passenger_application/model/homestay_model.dart';

abstract class ChooseBlocServiceEvent {}

class OnChooseServiceEvent extends ChooseBlocServiceEvent {
  OnChooseServiceEvent({this.homestayServiceModel});

  HomestayServiceModel? homestayServiceModel;
}

class OnNextStepToViewHomestayInBlocFacilityEvent
    extends ChooseBlocServiceEvent {
  OnNextStepToViewHomestayInBlocFacilityEvent(
      {this.context,
      this.bookingStart,
      this.bookingEnd,
      this.bookingBlocList,
      this.blocServiceList,
      this.bookingId,
      this.bloc,
      this.totalHomestayPrice,
      this.totalServicePrice});

  BuildContext? context;
  String? bookingStart;
  String? bookingEnd;
  List<BookingBlocModel>? bookingBlocList;
  List<HomestayServiceModel>? blocServiceList;
  int? bookingId;
  BlocHomestayModel? bloc;
  int? totalHomestayPrice;
  int? totalServicePrice;
}
