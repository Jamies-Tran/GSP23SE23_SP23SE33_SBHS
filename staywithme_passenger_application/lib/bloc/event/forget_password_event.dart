import 'package:flutter/material.dart';

abstract class ForgetPasswordEvent {}

class InputEmailEvent extends ForgetPasswordEvent {
  InputEmailEvent({this.email});

  String? email;
}

class InputOtpEvent extends ForgetPasswordEvent {
  InputOtpEvent({this.otp});

  String? otp;
}

class BackwardToLoginScreenEvent extends ForgetPasswordEvent {
  BackwardToLoginScreenEvent({this.context});

  BuildContext? context;
}

class ForwardToSendOtpScreenEvent extends ForgetPasswordEvent {
  ForwardToSendOtpScreenEvent({this.context, this.email});

  String? email;
  BuildContext? context;
}

class ForwardToSendMailScreenEvent extends ForgetPasswordEvent {
  ForwardToSendMailScreenEvent({this.context, this.email});

  String? email;
  BuildContext? context;
}

class ForwardToValidateOtpScreenEvent extends ForgetPasswordEvent {
  ForwardToValidateOtpScreenEvent({this.context, this.otp, this.email});

  String? otp;
  String? email;
  BuildContext? context;
}

class ForwardToChangePasswordScreenEvent extends ForgetPasswordEvent {
  ForwardToChangePasswordScreenEvent({this.context, this.email});

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
