import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class RegisterEvent {}

class InputUsernameEvent extends RegisterEvent {
  InputUsernameEvent({this.username});

  String? username;
}

class InputPasswordEvent extends RegisterEvent {
  InputPasswordEvent({this.password});

  String? password;
}

class InputEmailEvent extends RegisterEvent {
  InputEmailEvent({this.email});

  String? email;
}

class InputAddressEvent extends RegisterEvent {
  InputAddressEvent({this.address});

  String? address;
}

class InputPhoneEvent extends RegisterEvent {
  InputPhoneEvent({this.phone});

  String? phone;
}

class ChooseGenderEvent extends RegisterEvent {
  ChooseGenderEvent({this.gender});

  String? gender;
}

class InputidCardNumberEvent extends RegisterEvent {
  InputidCardNumberEvent({this.idCardNumber});

  String? idCardNumber;
}

class InputDobEvent extends RegisterEvent {
  InputDobEvent({this.dob});

  String? dob;
}

class InputAvatarUrlEvent extends RegisterEvent {
  InputAvatarUrlEvent({this.avatarUrl});

  String? avatarUrl;
}

class FocusTextFieldRegisterEvent extends RegisterEvent {
  FocusTextFieldRegisterEvent(
      {this.isFocusOnUsername,
      this.isFocusOnPassword,
      this.isFocusOnEmail,
      this.isFocusOnAddress,
      this.isFocusOnPhone,
      this.isFocusOnCitizenIdentification,
      this.isFocusOnBirthday});

  bool? isFocusOnUsername;
  bool? isFocusOnPassword;
  bool? isFocusOnEmail;
  bool? isFocusOnPhone;
  bool? isFocusOnAddress;
  bool? isFocusOnCitizenIdentification;
  bool? isFocusOnBirthday;
}

class ChooseGoogleAccountEvent extends RegisterEvent {
  ChooseGoogleAccountEvent({this.context});

  BuildContext? context;
}

class ValidateGoogleAccountEvent extends RegisterEvent {
  ValidateGoogleAccountEvent({this.googleSignIn, this.context});

  GoogleSignIn? googleSignIn;
  BuildContext? context;
}

class NavigateToCompleteGoogelRegScreenEvent extends RegisterEvent {
  NavigateToCompleteGoogelRegScreenEvent(
      {this.context, this.googleSignIn, this.googleSignInAccount});

  BuildContext? context;
  GoogleSignIn? googleSignIn;
  GoogleSignInAccount? googleSignInAccount;
}

class NaviageToLoginScreenEvent extends RegisterEvent {
  NaviageToLoginScreenEvent({this.context});

  BuildContext? context;
}

class SubmitRegisterAccountEvent extends RegisterEvent {
  SubmitRegisterAccountEvent(
      {this.username,
      this.password,
      this.email,
      this.address,
      this.phone,
      this.gender,
      this.idCardNumber,
      this.dob,
      this.avatarUrl,
      this.context});

  String? username;
  String? password;
  String? email;
  String? address;
  String? phone;
  String? gender;
  String? idCardNumber;
  String? dob;
  String? avatarUrl;
  BuildContext? context;
}
