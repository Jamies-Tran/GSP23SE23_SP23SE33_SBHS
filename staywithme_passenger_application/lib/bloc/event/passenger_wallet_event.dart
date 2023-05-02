import 'package:flutter/material.dart';

abstract class PassengerWalletEvent {}

class ChoosePaymentHistoriesEvent extends PassengerWalletEvent {
  ChoosePaymentHistoriesEvent();
}

class ChooseDepositsEvent extends PassengerWalletEvent {
  ChooseDepositsEvent();
}

class AddBalanceEvent extends PassengerWalletEvent {
  AddBalanceEvent({this.context});

  BuildContext? context;
}

class NextDepositEvent extends PassengerWalletEvent {
  NextDepositEvent({this.maxSize});
  int? maxSize;
}

class PreviousDepositEvent extends PassengerWalletEvent {
  PreviousDepositEvent();
}
