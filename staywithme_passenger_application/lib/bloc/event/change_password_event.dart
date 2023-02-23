import 'package:flutter/material.dart';

abstract class ChangePasswordEvent {}

class InputNewPasswordEvent extends ChangePasswordEvent {
  InputNewPasswordEvent({this.newPassword});

  String? newPassword;
}

class InputRePasswordEvent extends ChangePasswordEvent {
  InputRePasswordEvent({this.rePassword});

  String? rePassword;
}

class BackWardToChangePasswordScreenEvent extends ChangePasswordEvent {
  BackWardToChangePasswordScreenEvent(
      {this.msg, this.isExcOccured, this.context, this.email});

  String? email;
  String? msg;
  bool? isExcOccured;
  BuildContext? context;
}

class ChangePasswordSuccessEvent extends ChangePasswordEvent {
  ChangePasswordSuccessEvent({this.context});

  BuildContext? context;
}
