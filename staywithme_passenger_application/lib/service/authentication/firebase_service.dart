import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:staywithme_passenger_application/model/login_model.dart';

abstract class IFirebaseService {
  Future<dynamic> saveLoginInfo(LoginModel loginModel);

  Future<dynamic> deleteLoginInfo(String email);
}

class FirebaseServcie extends IFirebaseService {
  final _firebase = FirebaseFirestore.instance.collection("authentication");

  @override
  Future saveLoginInfo(LoginModel loginModel) async {
    await _firebase.add({
      "username": loginModel.username,
      "email": loginModel.email,
      "token": loginModel.token,
      "expireDate": loginModel.expireDate
    });
  }

  @override
  Future deleteLoginInfo(String email) async {
    final result = await _firebase.where("email", isEqualTo: email).get();
    await _firebase.doc(result.docs[0].id).delete();
  }
}
