import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';

import '../model/passenger_model.dart';

abstract class IAuthenticateByGoogleService {
  Future<dynamic> authenticateByGoogle(GoogleSignInAccount googleSignInAccount);

  Future<dynamic> signOut();

  Future<dynamic> validateGoogleAccount(
      GoogleSignInAccount googleSignInAccount);

  Future<dynamic> registerGoogleAccount(PassengerModel passengerModel);

  Future<dynamic> informLoginToFireAuth(String email, String password);
}

class AuthenticateByGoogleService extends IAuthenticateByGoogleService {
  final _firebaseAuth = FirebaseAuth.instance;

  GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Future authenticateByGoogle(GoogleSignInAccount googleSignInAccount) async {
    try {
      final googleAuthentication = await googleSignInAccount.authentication;
      final googleCredential = GoogleAuthProvider.credential(
          idToken: googleAuthentication.idToken,
          accessToken: googleAuthentication.accessToken);
      final signInWithGoogle =
          await _firebaseAuth.signInWithCredential(googleCredential);

      return signInWithGoogle;
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future signOut() async {
    try {
      googleSignIn
          .signOut()
          .timeout(Duration(seconds: connectionTimeOut))
          .then((value) async {
        await _firebaseAuth
            .signOut()
            .timeout(Duration(seconds: connectionTimeOut));
      });
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future validateGoogleAccount(GoogleSignInAccount googleSignInAccount) async {
    var client = http.Client();
    final actualEmailValidateUrl =
        "$emailValidateUrl?email=${googleSignInAccount.email}";
    final uri = Uri.parse(actualEmailValidateUrl);
    try {
      final response = await client.get(uri, headers: {
        "content-type": "application/json"
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future registerGoogleAccount(PassengerModel passengerModel) async {
    final client = http.Client();
    Uri uri = Uri.parse(registerUrl);
    try {
      final response = await client
          .post(uri,
              headers: {"content-type": "application/json"},
              body: json.encode(passengerModel.toJson()))
          .timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 201) {
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
  Future informLoginToFireAuth(String email, String password) async {
    print(email.split("@").first);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: email.split("@").first);
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      }
    }
  }
}
