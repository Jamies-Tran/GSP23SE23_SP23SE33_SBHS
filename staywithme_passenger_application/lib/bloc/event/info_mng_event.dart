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

class NavigateToBookingHistoryScreenEvent extends InfoManagementEvent {
  NavigateToBookingHistoryScreenEvent({this.context});

  BuildContext? context;
}

class ActiveInputInviteCodeEvent extends InfoManagementEvent {
  ActiveInputInviteCodeEvent({this.context});

  BuildContext? context;
}

class SubmitInviteCodeEvent extends InfoManagementEvent {
  SubmitInviteCodeEvent({this.inviteCode, this.context});

  String? inviteCode;
  BuildContext? context;
}

class InputInviteCodeEvent extends InfoManagementEvent {
  InputInviteCodeEvent({this.inviteCode});

  String? inviteCode;
}

class SignOutEvent extends InfoManagementEvent {
  SignOutEvent({this.context});
  BuildContext? context;
}
