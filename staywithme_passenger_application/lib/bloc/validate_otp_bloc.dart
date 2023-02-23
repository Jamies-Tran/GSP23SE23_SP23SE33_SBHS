import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/validate_otp_event.dart';
import 'package:staywithme_passenger_application/bloc/state/validate_otp_state.dart';
import 'package:staywithme_passenger_application/screen/authenticate/change_password_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/validate_otp_screen.dart';

class ValidateOtpBloc {
  final eventController = StreamController<ValidateOtpEvent>();
  final stateController = StreamController<ValidateOtpState>();

  String? _otp;

  ValidateOtpState initData() => ValidateOtpState(otp: null);

  void dispose() {
    eventController.close();
    stateController.close();
  }

  ValidateOtpBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(ValidateOtpEvent event) {
    if (event is InputOtpEvent) {
      _otp = event.otp;
    } else if (event is ValidateOtpSuccessEvent) {
      Navigator.pushReplacementNamed(
          event.context!, ChangePasswordScreen.changePasswordScreenRoute,
          arguments: {"email": event.email});
    } else if (event is BackwardToValidateOtpScreenEvent) {
      Navigator.pushReplacementNamed(
          event.context!, ValidateOtpScreen.validateOtpScreen, arguments: {
        "isExcOccured": event.isExcOccured,
        "msg": event.msg,
        "email": event.email
      });
    }

    stateController.sink.add(ValidateOtpState(otp: _otp));
  }
}
