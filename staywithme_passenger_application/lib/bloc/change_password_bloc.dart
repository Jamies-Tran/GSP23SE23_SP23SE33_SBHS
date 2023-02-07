import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/change_password_event.dart';
import 'package:staywithme_passenger_application/bloc/state/change_password_state.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/screen/authenticate/change_password_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/log_in_screen.dart';
import 'package:staywithme_passenger_application/service/auth_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class ChangePasswordBloc {
  final eventController = StreamController<ChangePasswordEvent>();
  final stateController = StreamController<ChangePasswordState>();
  final _authService = locator.get<IAuthenticateService>();

  String? _newPassword;
  String? _rePassword;

  ChangePasswordState initData() =>
      ChangePasswordState(newPassword: "", rePassword: "");

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
    } else if (event is BackwardToChangePasswordScreenEvent) {
      Navigator.pushNamed(
          event.context!, ChangePasswordScreen.changePasswordScreenRoute,
          arguments: {"isExceptionOccured": true, "message": event.message});
    } else if (event is PasswordModificationEvent) {
      _authService
          .changePassword(event.newPassword!, event.email!)
          .then((value) {
        if (value is bool) {
          Navigator.pushNamed(event.context!, LoginScreen.loginScreenRoute);
        } else if (value is ServerExceptionModel) {
          Navigator.pushNamed(
              event.context!, ChangePasswordScreen.changePasswordScreenRoute,
              arguments: {
                "email": event.email,
                "isExceptionOccured": true,
                "message": value.message
              });
        } else if (value is TimeoutException || value is SocketException) {
          Navigator.pushNamed(
              event.context!, ChangePasswordScreen.changePasswordScreenRoute,
              arguments: {
                "email": event.email,
                "isExceptionOccured": true,
                "message": "Network error"
              });
        }
      });
    }

    stateController.sink.add(ChangePasswordState(
        newPassword: _newPassword, rePassword: _rePassword));
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }
}
