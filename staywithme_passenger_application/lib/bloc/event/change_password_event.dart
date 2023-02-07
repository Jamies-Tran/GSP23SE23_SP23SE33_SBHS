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

class PasswordModificationEvent extends ChangePasswordEvent {
  PasswordModificationEvent({this.context, this.email, this.newPassword});

  String? newPassword;
  String? email;
  BuildContext? context;
}

class BackwardToChangePasswordScreenEvent extends ChangePasswordEvent {
  BackwardToChangePasswordScreenEvent({this.context, this.message, this.email});

  String? message;
  String? email;
  BuildContext? context;
}
