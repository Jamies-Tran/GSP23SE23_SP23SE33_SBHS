import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:staywithme_passenger_application/global_variable.dart';
import 'package:staywithme_passenger_application/model/exc_model.dart';
import 'package:staywithme_passenger_application/model/homestay_city_province_model.dart';
import 'package:staywithme_passenger_application/model/passenger_model.dart';

abstract class IUserService {
  Future<dynamic> getPassengerPersonalInformation(String username);

  Future<dynamic> getAreaImage(String area);

  Future<dynamic> getAreaHomestayInfo();
}

class UserService extends IUserService {
  final storage = FirebaseStorage.instance.ref();

  @override
  Future getPassengerPersonalInformation(String username) async {
    final client = http.Client();
    Uri uri = Uri.parse("$userInfoUrl?username=$username");
    try {
      final response = await client.get(uri, headers: {
        "content-type": "application/json"
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

  @override
  Future getAreaImage(String area) async {
    String img = "$area.jpg";
    String url = await storage
        .child("homepage")
        .child("homepage_mobile")
        .child(img)
        .getDownloadURL();

    return url;
  }

  @override
  Future getAreaHomestayInfo() async {
    final client = http.Client();
    final uri = Uri.parse(cityProvincesUrl);
    try {
      final response =
          await client.get(uri, headers: {"content-type": "application/json"});
      if (response.statusCode == 200) {
        TotalHomestayFromLocationModel totalHomestayFromLocationModel =
            TotalHomestayFromLocationModel.fromJson(json.decode(response.body));
        if (totalHomestayFromLocationModel.totalHomestays!.isNotEmpty) {
          for (var e in totalHomestayFromLocationModel.totalHomestays!) {
            String avatarUrl =
                await getAreaImage(utf8.decode(e.cityProvince!.runes.toList()));
            e.avatarUrl = avatarUrl;
          }
        }

        if (totalHomestayFromLocationModel.totalBlocs!.isNotEmpty) {
          for (var e in totalHomestayFromLocationModel.totalBlocs!) {
            String avatarUrl =
                await getAreaImage(utf8.decode(e.cityProvince!.runes.toList()));
            e.avatarUrl = avatarUrl;
          }
        }
        return totalHomestayFromLocationModel;
      }
    } on SocketException catch (e) {
      return e;
    } on TimeoutException catch (e) {
      return e;
    }
  }
}
