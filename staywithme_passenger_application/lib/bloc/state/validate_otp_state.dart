class ValidateOtpState {
  ValidateOtpState({this.otp});

  String? otp;

  String? validateOtp() {
    if (otp == null || otp == "") {
      return "Enter otp";
    }

    return null;
  }
}
