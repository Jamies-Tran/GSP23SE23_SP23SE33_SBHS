import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staywithme_passenger_application/global_variable.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:staywithme_passenger_application/model/login_model.dart';

abstract class IFirebaseService {
  Future<dynamic> saveLoginInfo(LoginModel loginModel);

  Future<dynamic> deleteLoginInfo(String email);

  Future<dynamic> getUserTokenByUsername(String username);
}

class FirebaseServcie extends IFirebaseService {
  final _firebase = FirebaseFirestore.instance.collection("authentication");

  @override
  Future saveLoginInfo(LoginModel loginModel) async {
    try {
      await _firebase.add({
        "username": loginModel.username,
        "email": loginModel.email,
        "token": loginModel.token,
        "expireDate": loginModel.expireDate
      }).timeout(Duration(seconds: connectionTimeOut));
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future deleteLoginInfo(String email) async {
    try {
      final result = await _firebase
          .where("email", isEqualTo: email)
          .get()
          .timeout(Duration(seconds: connectionTimeOut));
      for (var element in result.docs) {
        element.reference.delete();
      }
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  @override
  Future getUserTokenByUsername(String username) async {
    try {
      final result = await _firebase
          .where("username", isEqualTo: username)
          .get()
          .timeout(Duration(seconds: connectionTimeOut));
      if (result.docs.isNotEmpty) {
        return result.docs[0].data()["token"];
      }

      return null;
    } on TimeoutException catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }
}
