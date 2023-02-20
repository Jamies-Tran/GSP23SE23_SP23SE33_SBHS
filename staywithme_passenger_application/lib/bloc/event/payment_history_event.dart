import 'package:flutter/material.dart';

abstract class PaymentHistoryEvent {}

class NextPageEvent extends PaymentHistoryEvent {
  NextPageEvent({this.context, this.username, this.pageNumber});

  BuildContext? context;
  String? username;
  int? pageNumber;
}

class PreviousPageEvent extends PaymentHistoryEvent {
  PreviousPageEvent({this.context, this.username, this.pageNumber});

  BuildContext? context;
  String? username;
  int? pageNumber;
}
