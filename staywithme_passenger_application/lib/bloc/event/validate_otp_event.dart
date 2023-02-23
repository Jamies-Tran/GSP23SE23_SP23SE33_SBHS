import 'package:flutter/material.dart';

abstract class ValidateOtpEvent {}

class InputOtpEvent extends ValidateOtpEvent {
  InputOtpEvent({this.otp});

  String? otp;
}

class BackwardToValidateOtpScreenEvent extends ValidateOtpEvent {
  BackwardToValidateOtpScreenEvent(
      {this.msg, this.context, this.email, this.isExcOccured});

  String? email;
  String? msg;
  bool? isExcOccured;
  BuildContext? context;
}

class ValidateOtpSuccessEvent extends ValidateOtpEvent {
  ValidateOtpSuccessEvent({this.email, this.context});

  String? email;
  BuildContext? context;
}
