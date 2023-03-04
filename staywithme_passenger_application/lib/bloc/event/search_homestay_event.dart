import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

abstract class SearchHomestayEvent {}

class OnClickChooseFilterEvent extends SearchHomestayEvent {
  OnClickChooseFilterEvent({this.context, this.position});

  Position? position;
  BuildContext? context;
}
