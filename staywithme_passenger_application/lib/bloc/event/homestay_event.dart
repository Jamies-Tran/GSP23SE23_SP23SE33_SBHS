import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

abstract class HomestayEvent {}

class OnClickSearchTextFieldEvent extends HomestayEvent {
  OnClickSearchTextFieldEvent({this.context, this.position});

  Position? position;
  BuildContext? context;
}
