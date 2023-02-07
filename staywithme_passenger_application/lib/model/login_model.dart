import 'dart:core';

class LoginModel {
  LoginModel(
      {this.username, this.email, this.password, this.token, this.expireDate});

  String? username;
  String? email;
  String? password;
  String? token;
  String? expireDate;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
      username: json["username"],
      email: json["email"],
      token: json["token"],
      expireDate: json["expireDate"]);

  Map<String, dynamic> toJson() => {"username": username, "password": password};
}
