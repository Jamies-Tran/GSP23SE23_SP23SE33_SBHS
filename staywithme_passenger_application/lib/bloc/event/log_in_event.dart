import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class LogInEvent {}

class InputUsernameLoginEvent extends LogInEvent {
  InputUsernameLoginEvent({this.username});

  String? username;
}

class InputPasswordLoginEvent extends LogInEvent {
  InputPasswordLoginEvent({this.password});

  String? password;
}

class FocusTextFieldLoginEvent extends LogInEvent {
  FocusTextFieldLoginEvent({this.isFocusUsername, this.isFocusPassword});

  bool? isFocusUsername;
  bool? isFocusPassword;
}

class ShowPasswordLoginEvent extends LogInEvent {
  ShowPasswordLoginEvent({this.isShowPassword});

  bool? isShowPassword;
}

class NavigateToRegScreenEvent extends LogInEvent {
  NavigateToRegScreenEvent({this.context});

  BuildContext? context;
}

class ChooseGoogleAccountEvent extends LogInEvent {
  ChooseGoogleAccountEvent({this.context});

  BuildContext? context;
}

class ValidateGoogleAccountLoginEvent extends LogInEvent {
  ValidateGoogleAccountLoginEvent({this.context, this.googleSignIn});

  BuildContext? context;
  GoogleSignIn? googleSignIn;
}

class LogInByGoogleAccountEvent extends LogInEvent {
  LogInByGoogleAccountEvent({this.context, this.googleSignIn});

  BuildContext? context;
  GoogleSignIn? googleSignIn;
}

class LogInSuccessEvent extends LogInEvent {
  LogInSuccessEvent({this.context, this.email, this.username});

  String? email;
  String? username;
  BuildContext? context;
}

class InformLoginToFireAuthEvent extends LogInEvent {
  InformLoginToFireAuthEvent({this.context, this.email, this.username});

  BuildContext? context;
  String? username;
  String? email;
}

class LogInFailEvent extends LogInEvent {
  LogInFailEvent({this.context, this.message, this.excCount});

  BuildContext? context;
  int? excCount;
  String? message;
}

// class SubmitLoginEvent extends LogInEvent {
//   SubmitLoginEvent({this.context, this.excCount});

//   BuildContext? context;
//   int? excCount;
// }

class BackwardToLoginScreenEvent extends LogInEvent {
  BackwardToLoginScreenEvent({this.context, this.message});

  BuildContext? context;
  String? message;
}

class NavigateToForgetPasswordScreenEvent extends LogInEvent {
  NavigateToForgetPasswordScreenEvent({this.context});

  BuildContext? context;
}
