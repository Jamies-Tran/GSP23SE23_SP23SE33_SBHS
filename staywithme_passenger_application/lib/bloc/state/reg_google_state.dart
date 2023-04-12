import 'package:flutter/material.dart';

class CompleteGoogleRegisterState {
  CompleteGoogleRegisterState(
      {this.username,
      this.email,
      this.phone,
      this.address,
      this.idCardNumber,
      this.gender,
      this.dob,
      this.avatarUrl,
      this.focusAddressColor,
      this.focusBirthDayColor,
      this.focusIdCardNumberColor,
      this.focusPhoneColor,
      this.focusUsernameColor});

  String? username;
  String? email;
  String? phone;
  String? address;
  String? idCardNumber;
  String? gender;
  String? avatarUrl;
  String? dob;

  Color? focusUsernameColor;
  Color? focusPhoneColor;
  Color? focusAddressColor;
  Color? focusIdCardNumberColor;
  Color? focusBirthDayColor;

  String? validateUsername() {
    if (username == null || username == "") {
      return "Enter username";
    }

    return null;
  }

  String? validateEmail() {
    if (email == null || email == "") {
      return "Enter email";
    }

    return null;
  }

  String? validatePhone() {
    if (phone == null || phone == "") {
      return "Enter phone";
    } else if (phone!.length > 10 || phone!.length < 10) {
      return "Invalid phone number";
    }

    return null;
  }

  String? validateAddress() {
    if (address == null || address == "") {
      return "Enter address";
    }

    return null;
  }

  String? validateIdCardNumber() {
    if (idCardNumber == null || idCardNumber == "") {
      return "Enter citizen identification";
    }

    return null;
  }

  String? validateDob() {
    if (dob == null || dob == "") {
      return "Enter your birthday";
    }

    return null;
  }
}
