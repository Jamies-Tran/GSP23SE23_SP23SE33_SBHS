import 'package:flutter/material.dart';

abstract class InfoManagementEvent {}

class NavigateToAddBalanceScreenEvent extends InfoManagementEvent {
  NavigateToAddBalanceScreenEvent({this.context, this.username});

  BuildContext? context;
  String? username;
}

class NavigateToPaymentHistoryScreenEvent extends InfoManagementEvent {
  NavigateToPaymentHistoryScreenEvent({this.context, this.username});

  BuildContext? context;
  String? username;
}
