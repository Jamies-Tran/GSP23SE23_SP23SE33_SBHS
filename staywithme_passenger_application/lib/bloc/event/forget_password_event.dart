import 'package:flutter/material.dart';

abstract class ForgetPasswordEvent {}

class InputEmailEvent extends ForgetPasswordEvent {
  InputEmailEvent({this.email});

  String? email;
}

class BackwardToLoginScreenEvent extends ForgetPasswordEvent {
  BackwardToLoginScreenEvent({this.context});

  BuildContext? context;
}

class ForwardToSendMailScreenEvent extends ForgetPasswordEvent {
  ForwardToSendMailScreenEvent({this.context, this.email});

  String? email;
  BuildContext? context;
}

class BackwardToSendOtpByMailScreenEvent extends ForgetPasswordEvent {
  BackwardToSendOtpByMailScreenEvent({this.context, this.email, this.message});

  String? email;
  String? message;
  BuildContext? context;
}

class BackwardToValidateOtpScreenEvent extends ForgetPasswordEvent {
  BackwardToValidateOtpScreenEvent({this.context, this.email, this.message});

  String? email;
  String? message;
  BuildContext? context;
}
