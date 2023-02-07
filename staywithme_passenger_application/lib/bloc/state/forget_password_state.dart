class ForgetPasswordState {
  ForgetPasswordState({this.email, this.otp});

  String? email;

  String? otp;

  String? validateEmail() {
    if (email == null || email == "") {
      return "Please enter email";
    }

    return null;
  }

  String? validateOtp() {
    if (otp == null || otp == "") {
      return "Please enter otp";
    }

    return null;
  }
}
