class ChangePasswordState {
  ChangePasswordState({this.newPassword, this.rePassword});

  String? newPassword;
  String? rePassword;

  String? validateNewPassword() {
    if (newPassword == null || newPassword == "") {
      return "Please enter password";
    } else if (newPassword != rePassword) {
      return "re-password not match";
    }

    return null;
  }

  String? validateRePassword() {
    if (rePassword == null || rePassword == "") {
      return "Please enter password";
    } else if (newPassword != rePassword) {
      return "re-password not match";
    }

    return null;
  }
}
