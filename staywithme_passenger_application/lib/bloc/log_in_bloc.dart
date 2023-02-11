import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:staywithme_passenger_application/bloc/event/log_in_event.dart';
import 'package:staywithme_passenger_application/bloc/state/log_in_state.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/login_model.dart';
import 'package:staywithme_passenger_application/screen/authenticate/authenticate_wrapper.dart';
import 'package:staywithme_passenger_application/screen/authenticate/forget_password_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/google_chosen_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/google_validation_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/log_in_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/register_screen.dart';
import 'package:staywithme_passenger_application/service/authentication/auth_service.dart';
import 'package:staywithme_passenger_application/service/authentication/firebase_service.dart';
import 'package:staywithme_passenger_application/service/authentication/google_auth_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

class LoginBloc {
  final eventController = StreamController<LogInEvent>();
  final stateController = StreamController<LoginState>();

  final _authService = locator.get<IAuthenticateService>();
  final _firebaseAuth = locator.get<IAuthenticateByGoogleService>();

  bool _isShowPassword = true;

  LoginState initData() => LoginState(
      username: null,
      password: null,
      focusUsernameColor: Colors.white,
      focusPasswordColor: Colors.white,
      isShowPassword: true);

  String? _username;
  String? _password;

  Color? _focusUsernameColor;
  Color? _focusPasswordColor;

  LoginBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(LogInEvent event) {
    if (event is InputUsernameLoginEvent) {
      _username = event.username;
    } else if (event is InputPasswordLoginEvent) {
      _password = event.password;
    } else if (event is FocusTextFieldLoginEvent) {
      _focusUsernameColor =
          event.isFocusUsername == true ? Colors.black45 : Colors.white;
      _focusPasswordColor =
          event.isFocusPassword == true ? Colors.black45 : Colors.white;
    } else if (event is ShowPasswordLoginEvent) {
      _isShowPassword = !_isShowPassword;
    } else if (event is BackwardToLoginScreenEvent) {
      Navigator.pushNamed(event.context!, LoginScreen.loginScreenRoute,
          arguments: {"isExceptionOccured": true, "message": event.message});
    } else if (event is NavigateToRegScreenEvent) {
      Navigator.of(event.context!)
          .pushNamed(RegisterScreen.registerAccountRoute);
    } else if (event is LogInSuccessEvent) {
      Navigator.pushNamed(
          event.context!, LoginLoadingScreen.loginLoadingScreenRoute,
          arguments: {"email": event.email, "username": event.username});
    } else if (event is InformLoginToFireAuthEvent) {
      _firebaseAuth.informLoginToFireAuth(event.email!).then((value) =>
          _firebaseAuth.updateFirebaseUsername(event.username!).then((value) =>
              Navigator.pushReplacementNamed(event.context!,
                  AuthenticateWrapperScreen.authenticateWrapperScreenRoute)));
    } else if (event is LogInFailEvent) {
      int? excCount = event.excCount;
      excCount = excCount != null ? excCount += 1 : null;

      Navigator.pushReplacementNamed(
          event.context!, LoginScreen.loginScreenRoute, arguments: {
        "isExceptionOccured": true,
        "message": event.message,
        "excCount": excCount
      });
    } else if (event is ChooseGoogleAccountEvent) {
      Navigator.pushNamed(event.context!,
          ChooseGoogleAccountScreen.chooseGoogleAccountScreenRoute,
          arguments: {"isGoogleRegister": false});
    } else if (event is ValidateGoogleAccountLoginEvent) {
      Navigator.pushNamed(event.context!,
          GoogleAccountValidationScreen.checkValidGoogleAccountRoute,
          arguments: {
            "isGoogleRegister": false,
            "googleSignIn": event.googleSignIn
          });
    } else if (event is LogInByGoogleAccountEvent) {
      _authService.googleLogin(event.googleSignIn!.currentUser!).then((value) {
        if (value is ServerExceptionModel) {
          Navigator.pushNamed(event.context!, LoginScreen.loginScreenRoute,
              arguments: {
                "isExceptionOccured": true,
                "message": value.message
              });
        } else if (value is TimeoutException || value is SocketException) {
          Navigator.pushReplacementNamed(
              event.context!, LoginScreen.loginScreenRoute, arguments: {
            "isExceptionOccured": true,
            "message": "Network error"
          });
        } else {
          Navigator.pushNamed(event.context!,
              AuthenticateWrapperScreen.authenticateWrapperScreenRoute,
              arguments: {
                "username": event.googleSignIn!.currentUser!.displayName
              });
        }
      });
    } else if (event is NavigateToForgetPasswordScreenEvent) {
      Navigator.pushNamed(
          event.context!, ForgetPasswordScreen.forgetPasswordRoute,
          arguments: {"isForgetPassword": true});
    }

    stateController.sink.add(LoginState(
        username: _username,
        password: _password,
        focusUsernameColor: _focusUsernameColor,
        focusPasswordColor: _focusPasswordColor,
        isShowPassword: _isShowPassword));
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }
}
