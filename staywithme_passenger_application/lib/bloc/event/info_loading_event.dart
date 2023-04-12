import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/model/passenger_model.dart';

abstract class InfoLoadingEvent {}

class OnLoadUserInfoEvent extends InfoLoadingEvent {
  OnLoadUserInfoEvent({this.context, this.user});

  PassengerModel? user;
  BuildContext? context;
}

class SignOutOnErrorEvent extends InfoLoadingEvent {
  SignOutOnErrorEvent({this.context});

  BuildContext? context;
}
