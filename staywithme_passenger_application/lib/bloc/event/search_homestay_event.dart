import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

abstract class SearchHomestayEvent {}

class OnTabChooseFilterEvent extends SearchHomestayEvent {
  OnTabChooseFilterEvent({this.context, this.position, this.homestayType});

  Position? position;
  String? homestayType;
  BuildContext? context;
}

class OnTabChooseHomestayTypeEvent extends SearchHomestayEvent {
  OnTabChooseHomestayTypeEvent(
      {this.homestayType, this.position, this.context});

  String? homestayType;
  Position? position;
  BuildContext? context;
}
