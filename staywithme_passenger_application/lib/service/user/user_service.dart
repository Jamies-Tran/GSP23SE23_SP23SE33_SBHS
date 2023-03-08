import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/passenger_model.dart';
import 'package:staywithme_passenger_application/service/authentication/firebase_service.dart';
import 'package:staywithme_passenger_application/service_locator/service_locator.dart';

abstract class IUserService {
  Future<dynamic> getPassengerPersonalInformation(String username);
}

class UserService extends IUserService {
  final _firebaseService = locator.get<IFirebaseService>();

  @override
  Future getPassengerPersonalInformation(String username) async {
    final client = http.Client();
    Uri uri = Uri.parse("$userInfoUrl?username=$username");
    try {
      final response = await client.get(uri, headers: {
        "content-type": "application/json",
      }).timeout(Duration(seconds: connectionTimeOut));
      if (response.statusCode == 200) {
        PassengerModel passenger =
            PassengerModel.fromJson(json.decode(response.body));
        return passenger;
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
