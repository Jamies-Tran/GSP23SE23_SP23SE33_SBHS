import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/change_password_event.dart';
import 'package:staywithme_passenger_application/bloc/state/change_password_state.dart';
import 'package:staywithme_passenger_application/screen/authenticate/change_password_screen.dart';
import 'package:staywithme_passenger_application/screen/main_screen.dart';

class ChangePasswordBloc {
  final eventController = StreamController<ChangePasswordEvent>();
  final stateController = StreamController<ChangePasswordState>();

  String? _newPassword;
  String? _rePassword;

  ChangePasswordState initData() =>
      ChangePasswordState(newPassword: null, rePassword: null);

  void dispose() {
    eventController.close();
    stateController.close();
  }

  ChangePasswordBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(ChangePasswordEvent event) {
    if (event is InputNewPasswordEvent) {
      _newPassword = event.newPassword;
    } else if (event is InputRePasswordEvent) {
      _rePassword = event.rePassword;
    } else if (event is ChangePasswordSuccessEvent) {
      Navigator.pushReplacementNamed(event.context!, MainScreen.mainScreenRoute,
          arguments: {"startingIndex": 1, "message": "Password changed"});
    } else if (event is BackWardToChangePasswordScreenEvent) {
      Navigator.pushReplacementNamed(
          event.context!, ChangePasswordScreen.changePasswordScreenRoute,
          arguments: {
            "isExcOccured": event.isExcOccured,
            "msg": event.msg,
            "email": event.email
          });
    }

    stateController.sink.add(ChangePasswordState(
        newPassword: _newPassword, rePassword: _rePassword));
  }
}
