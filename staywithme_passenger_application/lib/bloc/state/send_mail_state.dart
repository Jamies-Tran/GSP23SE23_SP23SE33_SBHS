class SendMailState {
  SendMailState({this.mail});

  String? mail;

  String? validateMail() {
    if (mail == null || mail == "") {
      return "Enter your registered email";
    }

    return null;
  }
}
