class ChangePasswordState {
  ChangePasswordState({this.newPassword, this.rePassword});

  String? newPassword;
  String? rePassword;

  String? validateNewPassword() {
    if (newPassword == null || newPassword == "") {
      return "Enter new password";
    }

    return null;
  }

  String? validateRePassword() {
    if (rePassword == null || rePassword == "") {
      return "Enter re-password";
    }

    return null;
  }

  bool isRePasswordValid() {
    return rePassword == newPassword;
  }
}
