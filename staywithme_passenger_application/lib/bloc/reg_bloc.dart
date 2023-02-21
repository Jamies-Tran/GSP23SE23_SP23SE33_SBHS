import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:staywithme_passenger_application/bloc/event/reg_event.dart';
import 'package:staywithme_passenger_application/bloc/state/reg_state.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/passenger_model.dart';
import 'package:staywithme_passenger_application/screen/authenticate/complete_google_reg_screen.dart';
import 'package:staywithme_passenger_application/screen/authenticate/register_screen.dart';
import 'package:staywithme_passenger_application/screen/main_screen.dart';
import 'package:staywithme_passenger_application/service/authentication/auth_service.dart';
import 'package:staywithme_passenger_application/service/authentication/google_auth_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

import '../screen/authenticate/google_chosen_screen.dart';
import '../screen/authenticate/google_validation_screen.dart';

class RegisterBloc {
  final eventController = StreamController<RegisterEvent>();

  final stateController = StreamController<RegisterState>();

  final authenticateService = locator.get<IAuthenticateService>();

  final _googleSignIn = GoogleSignIn();

  final _googleAuthService = locator.get<IAuthenticateByGoogleService>();

  String? _username;
  String? _password;
  String? _email;
  String? _address;
  String? _idCardNumber;
  String? _dob;
  String? _gender;
  String? _phone;
  String? _avatarUrl;
  final genderSelection = ["Male", "Female"];

  Color? _focusUsernameColor;
  Color? _focusPasswordColor;
  Color? _focusEmailColor;
  Color? _focusAddressColor;
  Color? _focusPhoneColor;
  Color? _focusCitizenIdentificationColor;
  Color? _focusBirthdayColor;

  final initData = RegisterState(
      username: null,
      address: null,
      avatarUrl: null,
      idCardNumber: null,
      dob: null,
      email: null,
      gender: "Male",
      password: null,
      phone: null,
      focusUsernameColor: Colors.white,
      focusPasswordColor: Colors.white,
      focusAddressColor: Colors.white,
      focusEmailColor: Colors.white,
      focusPhoneColor: Colors.white,
      focusCitizenIdentificationColor: Colors.white,
      focusBirthdayColor: Colors.white);

  RegisterBloc() {
    eventController.stream.listen((event) {
      eventHandler(event);
    });
  }

  void eventHandler(RegisterEvent event) {
    if (event is InputUsernameEvent) {
      _username = event.username;
    } else if (event is InputPasswordEvent) {
      _password = event.password;
    } else if (event is InputEmailEvent) {
      _email = event.email;
    } else if (event is InputAddressEvent) {
      _address = event.address;
    } else if (event is InputidCardNumberEvent) {
      _idCardNumber = event.idCardNumber;
    } else if (event is InputDobEvent) {
      _dob = event.dob;
    } else if (event is ChooseGenderEvent) {
      _gender = event.gender;
    } else if (event is InputPhoneEvent) {
      _phone = event.phone;
    } else if (event is InputAvatarUrlEvent) {
      _avatarUrl = event.avatarUrl;
    } else if (event is FocusTextFieldRegisterEvent) {
      _focusUsernameColor =
          event.isFocusOnUsername == true ? secondaryColor : Colors.white;
      _focusPasswordColor =
          event.isFocusOnPassword == true ? secondaryColor : Colors.white;
      _focusEmailColor =
          event.isFocusOnEmail == true ? secondaryColor : Colors.white;
      _focusAddressColor =
          event.isFocusOnAddress == true ? secondaryColor : Colors.white;
      _focusPhoneColor =
          event.isFocusOnPhone == true ? secondaryColor : Colors.white;
      _focusCitizenIdentificationColor =
          event.isFocusOnCitizenIdentification == true
              ? secondaryColor
              : Colors.white;
      _focusBirthdayColor =
          event.isFocusOnBirthday == true ? Colors.black45 : Colors.white;
    } else if (event is ChooseGoogleAccountEvent) {
      _googleSignIn.isSignedIn().then((value) {
        if (value == true) {
          _googleAuthService.signOut().then((value) {
            if (value is TimeoutException || value is SocketException) {
              Navigator.pushNamed(event.context!, MainScreen.mainScreenRoute,
                  arguments: {
                    "isExceptionOccured": true,
                    "message": "Network error",
                    "startingIndex": 1
                  });
            }
          });
        }
      });
      Navigator.of(event.context!).pushNamed(
          ChooseGoogleAccountScreen.chooseGoogleAccountScreenRoute,
          arguments: {"isGoogleRegister": true});
    } else if (event is ValidateGoogleAccountEvent) {
      Navigator.pushReplacementNamed(event.context!,
          GoogleAccountValidationScreen.checkValidGoogleAccountRoute,
          arguments: {
            'googleSignIn': event.googleSignIn,
            "isGoogleRegister": true
          });
    } else if (event is NavigateToCompleteGoogelRegScreenEvent) {
      Navigator.of(event.context!).pushReplacementNamed(
          CompleteGoogleRegisterScreen.completeGoogleRegisterScreenRoute,
          arguments: {
            "googleSignInAccount": event.googleSignInAccount,
            "googleSignIn": event.googleSignIn
          });
    } else if (event is NaviageToLoginScreenEvent) {
      Navigator.of(event.context!).pushReplacementNamed(
          MainScreen.mainScreenRoute,
          arguments: {"startingIndex": 1});
    } else if (event is SubmitRegisterAccountEvent) {
      PassengerModel passenger = PassengerModel(
          username: event.username,
          password: event.password,
          email: event.email,
          address: event.address,
          phone: event.phone,
          idCardNumber: event.idCardNumber,
          dob: event.dob,
          gender: event.gender);
      authenticateService.registerAccount(passenger).then((value) {
        if (value is ServerExceptionModel) {
          Navigator.pushNamed(
              event.context!, RegisterScreen.registerAccountRoute, arguments: {
            "isExceptionOccured": true,
            "message": value.message
          });
        } else if (value is TimeoutException || value is SocketException) {
          Navigator.pushNamed(
              event.context!, RegisterScreen.registerAccountRoute, arguments: {
            "isExceptionOccured": true,
            "message": "Network error"
          });
        } else if (value is PassengerModel) {
          TextEditingController usernameTextEditingController =
              TextEditingController();
          usernameTextEditingController.text = value.username!;
          Navigator.pushReplacementNamed(
              event.context!, MainScreen.mainScreenRoute,
              arguments: {
                "usernameTextEditingController": usernameTextEditingController,
                "message": "account created",
                "startingIndex": 1
              });
        }
      });
    }
    stateController.sink.add(RegisterState(
        username: _username,
        password: _password,
        address: _address,
        avatarUrl: _avatarUrl,
        idCardNumber: _idCardNumber,
        dob: _dob,
        email: _email,
        gender: _gender,
        phone: _phone,
        focusUsernameColor: _focusUsernameColor,
        focusPasswordColor: _focusPasswordColor,
        focusEmailColor: _focusEmailColor,
        focusAddressColor: _focusAddressColor,
        focusPhoneColor: _focusPhoneColor,
        focusCitizenIdentificationColor: _focusCitizenIdentificationColor,
        focusBirthdayColor: _focusBirthdayColor));
  }

  void dispose() {
    eventController.close();
    stateController.close();
  }
}
