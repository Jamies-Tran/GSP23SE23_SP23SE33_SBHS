import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/passenger_wallet_event.dart';
import 'package:staywithme_passenger_application/bloc/state/passenger_wallet_state.dart';
import 'package:staywithme_passenger_application/model/passenger_model.dart';
import 'package:staywithme_passenger_application/screen/personal/add_balance_screen.dart';

class PassengerWalletBloc {
  final eventController = StreamController<PassengerWalletEvent>();
  final stateController = StreamController<PassengerWalletState>();

  PassengerModel? _user;
  int? _totalBalance;
  int? _totalDeposit;
  int? _actualBalance;
  bool? _isPaymentHistory;
  int? _currentDepositIndex = 0;

  PassengerWalletState initData(BuildContext context) {
    final contextArguments = ModalRoute.of(context)!.settings.arguments as Map;
    _user = contextArguments["user"];
    _totalBalance =
        _user!.passengerPropertyModel!.balanceWalletModel!.totalBalance!;
    _totalDeposit = _user!
        .passengerPropertyModel!.balanceWalletModel!.passengerWalletModel!
        .totalDeposit();
    _actualBalance =
        _user!.passengerPropertyModel!.balanceWalletModel!.actualBalance;
    return PassengerWalletState(
        user: contextArguments["user"],
        totalBalance: _totalBalance,
        totalDeposits: _totalDeposit,
        actualBalance: _actualBalance,
        isPaymentHistory: true,
        currentDepositIndex: 0);
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }

  PassengerWalletBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(PassengerWalletEvent event) {
    if (event is AddBalanceEvent) {
      Navigator.pushNamed(
          event.context!, AddBalanceScreen.addBalanceScreenRoute,
          arguments: {"username": _user!.username});
    } else if (event is ChoosePaymentHistoriesEvent) {
      _isPaymentHistory = true;
    } else if (event is ChooseDepositsEvent) {
      _isPaymentHistory = false;
    } else if (event is NextDepositEvent) {
      if (_currentDepositIndex! < event.maxSize! - 1) {
        _currentDepositIndex = _currentDepositIndex! + 1;
      }
    } else if (event is PreviousDepositEvent) {
      if (_currentDepositIndex! >= 1) {
        _currentDepositIndex = _currentDepositIndex! - 1;
      }
    }
    stateController.sink.add(PassengerWalletState(
        user: _user,
        totalBalance: _totalBalance,
        totalDeposits: _totalDeposit,
        actualBalance: _actualBalance,
        isPaymentHistory: _isPaymentHistory,
        currentDepositIndex: _currentDepositIndex));
  }
}
