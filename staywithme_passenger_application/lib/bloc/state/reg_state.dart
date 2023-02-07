import 'package:flutter/material.dart';

class RegisterState {
  RegisterState(
      {this.username,
      this.password,
      this.email,
      this.address,
      this.gender,
      this.idCardNumber,
      this.avatarUrl,
      this.dob,
      this.phone,
      this.focusUsernameColor,
      this.focusPasswordColor,
      this.focusEmailColor,
      this.focusAddressColor,
      this.focusPhoneColor,
      this.focusCitizenIdentificationColor,
      this.focusBirthdayColor});

  String? username;
  String? password;
  String? email;
  String? address;
  String? phone;
  String? gender;
  String? idCardNumber;
  String? dob;
  String? avatarUrl;

  Color? focusUsernameColor;
  Color? focusPasswordColor;
  Color? focusEmailColor;
  Color? focusAddressColor;
  Color? focusPhoneColor;
  Color? focusCitizenIdentificationColor;
  Color? focusBirthdayColor;

  String? validateUsername() {
    if (username == "" || username == null) {
      return "Enter username";
    }

    return null;
  }

  String? validatePassword() {
    if (password == "" || password == null) {
      return "Enter password";
    }

    return null;
  }

  String? validateEmail() {
    if (email == "" || email == null) {
      return "Enter email";
    }

    return null;
  }

  String? validateAddress() {
    if (address == "" || address == null) {
      return "Enter address";
    }

    return null;
  }

  String? validateGender() {
    if (gender == "" || gender == null) {
      return "Enter gender";
    }

    return null;
  }

  String? validateCitizenIdentification() {
    if (idCardNumber == "" || idCardNumber == null) {
      return "Enter citizen identification";
    }

    return null;
  }

  String? validateDob() {
    if (dob == "" || dob == null) {
      return "Enter day of birth";
    }

    return null;
  }

  String? validateAvatarUrl() {
    if (avatarUrl == "" || avatarUrl == null) {
      return "Enter avatar url";
    }

    return null;
  }

  String? validatePhone() {
    if (phone == "" || phone == null) {
      return "Enter phone";
    }

    return null;
  }
}
