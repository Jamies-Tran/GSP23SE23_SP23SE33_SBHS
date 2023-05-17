import 'dart:core';

class LoginModel {
  LoginModel(
      {this.username,
      this.email,
      this.password,
      this.token,
      this.expireDate,
      this.roles});

  String? username;
  String? email;
  String? password;
  String? token;
  String? expireDate;
  List<String>? roles;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
      username: json["username"],
      email: json["email"],
      token: json["token"],
      expireDate: json["expireDate"],
      roles: List<String>.from(json["roles"].map((e) => e.toString())));

  Map<String, dynamic> toJson() => {"username": username, "password": password};
}
