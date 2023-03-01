import 'package:flutter/material.dart';

abstract class HomestayEvent {}

class OnClickSearchTextFieldEvent extends HomestayEvent {
  OnClickSearchTextFieldEvent({this.context});

  BuildContext? context;
}
