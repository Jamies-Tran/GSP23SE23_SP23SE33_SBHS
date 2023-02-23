import 'package:flutter/material.dart';

abstract class SendMailEvent {}

class InputMailEvent extends SendMailEvent {
  InputMailEvent({this.mail});

  String? mail;
}

class BackwardToSendMailScreen extends SendMailEvent {
  BackwardToSendMailScreen(
      {this.msg, this.isExcOccured, this.email, this.context});

  String? email;
  String? msg;
  bool? isExcOccured;
  BuildContext? context;
}

class SendMailSuccessEvent extends SendMailEvent {
  SendMailSuccessEvent({this.context, this.email});

  String? email;
  BuildContext? context;
}
