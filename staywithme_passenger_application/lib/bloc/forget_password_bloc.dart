import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/forget_password_event.dart';
import 'package:staywithme_passenger_application/bloc/state/forget_password_state.dart';
import 'package:staywithme_passenger_application/screen/authenticate/change_password_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/forget_password_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/log_in_screen.dart';
import 'package:staywithme_passenger_application/screen/main_screen.dart';

class ForgetPasswordBloc {
  final eventController = StreamController<ForgetPasswordEvent>();
  final stateController = StreamController<ForgetPasswordState>();

  String? _email;
  String? _otp;

  ForgetPasswordState initData() => ForgetPasswordState(email: "", otp: "");

  ForgetPasswordBloc() {
    eventController.stream.listen((event) => eventHandler(event));
  }

  void eventHandler(ForgetPasswordEvent event) {
    if (event is InputEmailEvent) {
      _email = event.email;
    } else if (event is InputOtpEvent) {
      _otp = event.otp;
    } else if (event is ForwardToSendOtpScreenEvent) {
      Navigator.pushReplacementNamed(
          event.context!, ForgetPasswordScreen.forgetPasswordRoute,
          arguments: {"email": event.email, "isForgetPassword": false});
    } else if (event is ForwardToSendMailScreenEvent) {
      Navigator.pushNamed(event.context!, SendMailScreen.sendMailScreenRoute,
          arguments: {"email": event.email});
    } else if (event is ForwardToValidateOtpScreenEvent) {
      Navigator.pushNamed(
          event.context!,
          ValidatePasswordModificationOtpScreen
              .validatePasswordModificationScreenRoute,
          arguments: {"otp": event.otp, "email": event.email});
    } else if (event is ForwardToChangePasswordScreenEvent) {
      Navigator.pushReplacementNamed(
          event.context!, ChangePasswordScreen.changePasswordScreenRoute,
          arguments: {"email": event.email});
    } else if (event is BackwardToLoginScreenEvent) {
      Navigator.pushNamed(event.context!, MainScreen.mainScreenRoute,
          arguments: {"startingIndex": 1});
    } else if (event is BackwardToSendOtpByMailScreenEvent) {
      Navigator.pushReplacementNamed(
          event.context!, ForgetPasswordScreen.forgetPasswordRoute,
          arguments: {
            "isForgetPassword": true,
            "email": event.email,
            "isExceptionOccured": true,
            "message": event.message
          });
    } else if (event is BackwardToValidateOtpScreenEvent) {
      Navigator.pushReplacementNamed(
          event.context!, ForgetPasswordScreen.forgetPasswordRoute,
          arguments: {
            "isForgetPassword": false,
            "email": event.email,
            "message": event.message,
            "isExceptionOccured": true
          });
    }

    stateController.sink.add(ForgetPasswordState(email: _email, otp: _otp));
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }
}
