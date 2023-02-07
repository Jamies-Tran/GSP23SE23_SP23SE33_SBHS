import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class CompleteGoogleRegisterEvent {}

class ForwardCompleteGoogleRegisterScreenEvent
    extends CompleteGoogleRegisterEvent {
  ForwardCompleteGoogleRegisterScreenEvent({this.context, this.googleSignIn});

  GoogleSignIn? googleSignIn;
  BuildContext? context;
}

class BackwardToRegisterScreenEvent extends CompleteGoogleRegisterEvent {
  BackwardToRegisterScreenEvent({this.context, this.message});

  BuildContext? context;
  String? message;
}

class CancelCompleteGoogleAccountRegisterEvent
    extends CompleteGoogleRegisterEvent {
  CancelCompleteGoogleAccountRegisterEvent(
      {this.context, this.googleSignIn, this.isChangeGoogleAccount});

  GoogleSignIn? googleSignIn;
  BuildContext? context;
  bool? isChangeGoogleAccount;
}

class CancelChooseAnotherGoogleAccountEvent
    extends CompleteGoogleRegisterEvent {
  CancelChooseAnotherGoogleAccountEvent({this.context});

  BuildContext? context;
}

class SubmitGoogleCompleteRegisterEvent extends CompleteGoogleRegisterEvent {
  SubmitGoogleCompleteRegisterEvent(
      {this.username,
      this.email,
      this.phone,
      this.address,
      this.gender,
      this.idCardNumber,
      this.googleSignIn,
      this.dob,
      this.context});

  String? username;
  String? email;
  String? phone;
  String? address;
  String? gender;
  String? idCardNumber;
  GoogleSignIn? googleSignIn;
  String? dob;
  BuildContext? context;
}

class FocusTextFieldCompleteGoogleRegEvent extends CompleteGoogleRegisterEvent {
  FocusTextFieldCompleteGoogleRegEvent(
      {this.isFocusOnUsername,
      this.isFocusOnPhone,
      this.isFocusOnAddress,
      this.isFocusOnBirthDay,
      this.isFocusOnCitizenIdentification});

  bool? isFocusOnUsername;
  bool? isFocusOnPhone;
  bool? isFocusOnAddress;
  bool? isFocusOnCitizenIdentification;
  bool? isFocusOnBirthDay;
}

class InputUsernameGoogleAuthEvent extends CompleteGoogleRegisterEvent {
  InputUsernameGoogleAuthEvent({this.username});

  String? username;
}

class ReceiveEmailGoogleAuthEvent extends CompleteGoogleRegisterEvent {
  ReceiveEmailGoogleAuthEvent({this.email});

  String? email;
}

class InputPhoneGoogleAuthEvent extends CompleteGoogleRegisterEvent {
  InputPhoneGoogleAuthEvent({this.phone});

  String? phone;
}

class InputAddressGoogleAuthEvent extends CompleteGoogleRegisterEvent {
  InputAddressGoogleAuthEvent({this.address});

  String? address;
}

class ChooseGenderGoogleAuthEvent extends CompleteGoogleRegisterEvent {
  ChooseGenderGoogleAuthEvent({this.gender});

  String? gender;
}

class InputIdCardNumberGoogleAuthEvent extends CompleteGoogleRegisterEvent {
  InputIdCardNumberGoogleAuthEvent({this.idCardNumber});

  String? idCardNumber;
}

class InputAvatarUrlGoogleAuthEvent extends CompleteGoogleRegisterEvent {
  InputAvatarUrlGoogleAuthEvent({this.avatarUrl});

  String? avatarUrl;
}

class InputDobGoogleAuthEvent extends CompleteGoogleRegisterEvent {
  InputDobGoogleAuthEvent({this.dob});

  String? dob;
}

class BackToRegisterScreenEvent extends CompleteGoogleRegisterEvent {
  BackToRegisterScreenEvent({this.context});

  BuildContext? context;
}

class LoginByChosenEmailEvent extends CompleteGoogleRegisterEvent {
  LoginByChosenEmailEvent();
}
