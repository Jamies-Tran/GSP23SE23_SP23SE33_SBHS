import 'package:flutter/material.dart';

class LoginState {
  LoginState(
      {this.username,
      this.password,
      this.focusUsernameColor,
      this.focusPasswordColor,
      this.isShowPassword});

  String? username;
  String? password;

  Color? focusUsernameColor;
  Color? focusPasswordColor;

  bool? isShowPassword;

  String? validateUsername() {
    if (username == null || username == "") {
      return "Enter username";
    }

    return null;
  }

  String? validatePassword() {
    if (password == null || password == "") {
      return "Enter password";
    }

    return null;
  }
}
