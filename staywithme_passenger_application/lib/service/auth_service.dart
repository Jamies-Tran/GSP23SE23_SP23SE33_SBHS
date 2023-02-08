import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/login_model.dart';
import 'package:staywithme_passenger_application/model/passenger_model.dart';
import 'package:http/http.dart' as http;
import 'package:staywithme_passenger_application/service/firebase_service.dart';
import 'package:staywithme_passenger_application/service/google_auth_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

import '../global_variable.dart';

abstract class IAuthenticateService {
  Future<dynamic> registerAccount(PassengerModel passenger);

  Future<dynamic> login(LoginModel loginModel);

  Future<dynamic> googleLogin(GoogleSignInAccount googleSignInAccount);

  Future<dynamic> sendOtpByEmail(String email);

  Future<dynamic> validatePasswordModificationOtp(String otp);

  Future<dynamic> changePassword(String newPassword, String email);
}

class AuthenticateService extends IAuthenticateService {
  final _firebaseService = locator.get<IFirebaseService>();

  final _authByGoogleService = locator.get<IAuthenticateByGoogleService>();

  @override
  Future registerAccount(PassengerModel passenger) async {
    final client = http.Client();
    Uri registrationUri = Uri.parse(registerationUrl);
    try {
      final response = await client
          .post(registrationUri,
              headers: {"content-type": "application/json"},
              body: json.encode(passenger.toJson()))
          .timeout(Duration(seconds: connectionTimeOut));

      if (response.statusCode == 201) {
        PassengerModel passengerModel =
            PassengerModel.fromJson(json.decode(response.body));
        return passengerModel;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future login(LoginModel loginModel) async {
    final client = http.Client();
    Uri uri = Uri.parse(loginUrl);
    try {
      final response = await client
          .post(uri,
              headers: {"content-type": "application/json"},
              body: json.encode(loginModel.toJson()))
          .timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        final loginModel = LoginModel.fromJson(json.decode(response.body));
        _firebaseService.saveLoginInfo(loginModel).then((value) async =>
            await _authByGoogleService
                .informLoginToFireAuth(loginModel.email!));

        return loginModel;
      } else if (response.statusCode == 401) {
        final exceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return exceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future googleLogin(GoogleSignInAccount googleSignInAccount) async {
    final client = http.Client();
    Uri uri = Uri.parse("$googleLoginUrl?email=${googleSignInAccount.email}");
    try {
      final response = await client.get(uri, headers: {
        "content-type": "application/json"
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        LoginModel loginModel = LoginModel.fromJson(json.decode(response.body));
        _authByGoogleService
            .authenticateByGoogle(googleSignInAccount)
            .then((value) {
          if (value is TimeoutException || value is SocketException) {
            return value;
          }
        });
        return loginModel;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future sendOtpByEmail(String email) async {
    final client = http.Client();
    Uri uri = Uri.parse("$sendOtpByMailUrl?email=$email");
    try {
      final response = await client.get(uri, headers: {
        "content-type": "applicaiton/json"
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        return true;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future validatePasswordModificationOtp(String otp) async {
    final client = http.Client();
    Uri uri = Uri.parse("$otpVerificationUrl?otp=$otp");
    try {
      final response =
          await client.get(uri, headers: {"content-type": "application/json"});
      if (response.statusCode == 202) {
        return true;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future changePassword(String newPassword, String email) async {
    final client = http.Client();
    Uri uri = Uri.parse("$passwordModificationUrl?email=$email");
    try {
      final response = await client
          .put(uri,
              headers: {"content-type": "application/json"}, body: newPassword)
          .timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 202) {
        return true;
      } else {
        ServerExceptionModel serverExceptionModel =
            ServerExceptionModel.fromJson(json.decode(response.body));
        return serverExceptionModel;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }
}
