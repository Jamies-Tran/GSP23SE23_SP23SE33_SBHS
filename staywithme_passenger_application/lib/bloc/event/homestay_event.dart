import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

abstract class HomestayEvent {}

class OnClickSearchTextFieldEvent extends HomestayEvent {
  OnClickSearchTextFieldEvent({this.context, this.position, this.homestayType});

  Position? position;
  String? homestayType;
  BuildContext? context;
}

class OnClickAreaEvent extends HomestayEvent {
  OnClickAreaEvent(
      {this.position, this.homestayType, this.cityProvince, this.context});

  Position? position;
  String? homestayType;
  String? cityProvince;
  BuildContext? context;
}

class OnClickCampaignEvent extends HomestayEvent {
  OnClickCampaignEvent({this.context, this.position, this.campaignName});

  BuildContext? context;
  Position? position;
  String? campaignName;
}

class ViewHomestayDetailEvent extends HomestayEvent {
  ViewHomestayDetailEvent({this.context, this.homestayName});

  BuildContext? context;
  String? homestayName;
}

class ViewBlocHomestayDetailEvent extends HomestayEvent {
  ViewBlocHomestayDetailEvent({this.context, this.blocName});

  BuildContext? context;
  String? blocName;
}
