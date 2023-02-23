import 'dart:async';

import 'package:flutter/material.dart';
import 'package:staywithme_passenger_application/bloc/event/send_mail_event.dart';
import 'package:staywithme_passenger_application/bloc/state/send_mail_state.dart';
import 'package:staywithme_passenger_application/screen/authenticate/send_mail_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/validate_otp_screen.dart';

class SendMailBloc {
  final eventController = StreamController<SendMailEvent>();
  final stateController = StreamController<SendMailState>();

  String? _mail;

  SendMailState initData() => SendMailState(mail: null);

  SendMailBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(SendMailEvent event) {
    if (event is InputMailEvent) {
      _mail = event.mail;
    } else if (event is BackwardToSendMailScreen) {
      Navigator.pushReplacementNamed(
          event.context!, SendMailScreen.sendMailsCreenRoute, arguments: {
        "isExcOccured": event.isExcOccured,
        "msg": event.msg,
        "email": event.email
      });
    } else if (event is SendMailSuccessEvent) {
      Navigator.pushReplacementNamed(
          event.context!, ValidateOtpScreen.validateOtpScreen,
          arguments: {"email": event.email});
    }

    stateController.sink.add(SendMailState(mail: _mail));
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }
}
